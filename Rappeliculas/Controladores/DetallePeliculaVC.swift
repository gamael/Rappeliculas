//
//  DetallePeliculaVC.swift
//  Rappeliculas
//
//  Created by Alejandro Agudelo on 1/11/18.
//  Copyright © 2018 Alejandro Agudelo. All rights reserved.
//

import UIKit

class DetallePeliculaVC: UIViewController {
    
    var titulo = "Titulo"
    var fecha = "Fecha"
    var resumen = "Resumen"
    
    
    @IBOutlet var tituloLabel: UILabel!
    @IBOutlet var fechaLabel: UILabel!
    @IBOutlet var resumenTextView: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tituloLabel.text = titulo
        fechaLabel.text = "Fecha: " + fecha
        resumenTextView.text = resumen
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
