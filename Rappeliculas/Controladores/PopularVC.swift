//
//  PopularVC.swift
//  Rappeliculas
//
//  Created by Alejandro Agudelo on 6/11/18.
//  Copyright © 2018 Alejandro Agudelo. All rights reserved.
//

import UIKit
import Cards

class PopularVC: UIViewController {
    
    var servicios = Servicios()
    var peliculas = [PeliculaCD]()
    var dataController: DataController!

    @IBOutlet var stackView: UIStackView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.dataController.persistentContainer.persistentStoreDescriptions)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cargarPeliculas() {
        if let resultado = servicios.fetchPopularMovies(dataController: dataController) {
            peliculas = resultado
        }
        pintarcosas()
    }
    
    private func pintarcosas() -> Void {
        print(peliculas.count)
        for peli in peliculas {
            let card = CardHighlight(frame: CGRect(x: 10, y: 30, width: 200 , height: 240))
            
            card.backgroundColor = UIColor(red: 0, green: 94/255, blue: 112/255, alpha: 1)
            card.icon = UIImage(named: "ICtmdb")
            card.title = "Welcome \nto \nCards !"
            card.itemTitle = "Flappy Bird"
            card.itemSubtitle = "Flap That !"
            card.textColor = UIColor.white
            
            card.hasParallax = true
            card.translatesAutoresizingMaskIntoConstraints = false
            let cardContentVC = storyboard!.instantiateViewController(withIdentifier: "CardContent")
            card.shouldPresent(cardContentVC, from: self, fullscreen: false)
            DispatchQueue.main.async {
                self.stackView.addArrangedSubview(card)
            }
            
            NSLayoutConstraint.activate([
                
                card.widthAnchor.constraint(equalToConstant: 200),
                card.heightAnchor.constraint(equalToConstant: 240)
                ])
            
        }
        
    }
    


    // MARK: - Navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "verDetalle" {
//            let vc = segue.destination as! DetallePeliculaVC
//            let indiceSeleccionado = tableView.indexPathForSelectedRow?.row
//            vc.titulo = peliculas[indiceSeleccionado!].title!
//            vc.fecha = peliculas[indiceSeleccionado!].release_date!
//            vc.resumen = peliculas[indiceSeleccionado!].overview!
//        }
//
//    }
 
    
    
    
    
}
