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
        pintarCartas()
    }
    
    private func pintarCartas() -> Void {
        print(peliculas.count)
        for peli in peliculas {
            let card = CardHighlight(frame: CGRect(x: 10, y: 30, width: 200 , height: 240))
            
            card.backgroundColor = UIColor(red: 0, green: 94/255, blue: 112/255, alpha: 1)
            card.icon = UIImage(named: "ICtmdb")
            card.title = peli.title ?? "Sin titulo"
            card.itemTitle = peli.original_title ?? ""
            card.itemSubtitle = String(peli.release_date!.prefix(4))
            card.textColor = UIColor.white
            
            
            card.hasParallax = true
            card.translatesAutoresizingMaskIntoConstraints = false
            let cardContentVC = storyboard!.instantiateViewController(withIdentifier: "CardContent") as! DetallePeliculaVC
            cardContentVC.titulo = peli.title ?? "Sin titulo"
            cardContentVC.fecha = peli.release_date ?? "Sin Fecha"
            cardContentVC.resumen = peli.overview ?? "Sin resumen"
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
    
    
}
