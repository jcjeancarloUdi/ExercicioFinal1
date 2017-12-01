//
//  TableViewController.swift
//  ExercicioFinal1
//
//  Created by Jean on 01/12/2017.
//  Copyright © 2017 Jean. All rights reserved.
//

import UIKit
import DataKit

class TableViewController: UITableViewController, UISearchBarDelegate {

    let maxSections = 1
    let maxRows = 20
    lazy var data = [Int: [Objeto]]()
    lazy var originalData = [Int: [Objeto]]()
    var sectionSelect: Int = 0
    var rowSelect: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        data = generateObjetos(sections: maxSections, rows: maxRows)
        
        originalData = data
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        //guard data[section]!.count > 0 else {return "\(section)"}
    
        //return "\(data[section]![0].nome)"
        return ""
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var max = 0
        
        for (_, list) in data{
            if list.count > max {
                max = list.count
            }
        }
        
        return max
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return (data.count > originalData.count ? data.count : originalData.count)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "Cell", for: indexPath) as! TableViewCell
        
        if indexPath.row >= (data[indexPath.section]?.count)! || indexPath.row >= (data[indexPath.section]?.count)!{
            return tableView.dequeueReusableCell(
                withIdentifier: "PlaceHolder", for: indexPath) as! TableViewCell
        }

        let content = data[indexPath.section]![indexPath.row]

        cell.title.text = content.subtitulo
        cell.subTitle.text = content.descricao
        cell.img.image = content.image.image
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty{
            data = originalData
            
            self.tableView.reloadData()
            
            return
        }
        
        for (section, list) in originalData{
            let filtered = list.filter {
                let textToSearch = "\($0.nome) \($0.subtitulo)"
                return textToSearch.range(of: searchText) != nil
            }
            
            data[section] = filtered
        }
        
        self.tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete
        {
            self.data[indexPath.section]?.remove(at: indexPath.row)
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.endUpdates()
            
        }
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        sectionSelect = indexPath.section
        rowSelect = indexPath.row
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt indexPath: IndexPath, to: IndexPath) {
        let itemToMove = self.data[indexPath.section]![indexPath.row]
        self.data[indexPath.section]?.remove(at: indexPath.row)
        self.data[indexPath.section]?.insert(itemToMove, at: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let objeto = sender as! Objeto
        
        let controller = segue.destination as! ViewController
        
        controller.objeto = objeto
        
        
    }
     
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
     
         let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, IndexPath) in
            
            
            guard self.data[indexPath.section] != nil else {return}
            
            let objeto: Objeto = self.data[indexPath.section]![indexPath.row]
            
            self.performSegue(withIdentifier: "toDetail", sender: objeto)
            
         })
         editAction.backgroundColor = UIColor.blue
        
         let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, IndexPath) in
         self.data[indexPath.section]?.remove(at: indexPath.row)
         
         tableView.deleteRows(at: [IndexPath as IndexPath], with: .fade)
         })
         deleteAction.backgroundColor = UIColor.red
        
         return [editAction, deleteAction]
     }
    
    @IBAction func edit(_ sender: Any) {
        guard self.data[sectionSelect] != nil else {return}
        
        let objeto: Objeto = self.data[sectionSelect]![rowSelect]
        
        self.performSegue(withIdentifier: "toDetail", sender: objeto)
    }
    
    @IBAction func deleteSelect(_ sender: Any) {
        self.data[self.sectionSelect]?.remove(at: self.rowSelect)
        
        let indexPath: [IndexPath] = self.data[sectionSelect]![rowSelect] as! [IndexPath]
        self.tableView.deleteRows(at: indexPath, with: UITableViewRowAnimation.fade)
    }
    
    @IBAction func add(_ sender: Any) {
        
        self.performSegue(withIdentifier: "toDetail", sender: Objeto(nome: "",subtitulo: "",descricao: "",url: ""))
    }
    
}
