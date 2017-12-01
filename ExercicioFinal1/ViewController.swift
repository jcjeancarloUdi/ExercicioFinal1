//
//  ViewController.swift
//  ExercicioFinal1
//
//  Created by Jean on 01/12/2017.
//  Copyright © 2017 Jean. All rights reserved.
//

import UIKit
import DataKit

class ViewController: UIViewController {

    @IBOutlet weak var textoDetail: UITextField!
    @IBOutlet weak var addDetail: UIButton!
    @IBOutlet weak var imageDetail: UIImageView!
    
    public var objeto: Objeto? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard self.objeto != nil else {return}
        
        self.textoDetail.text = self.objeto?.descricao
        self.imageDetail.image = self.objeto?.image.image

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    


}
