//
//  PopularTVC.swift
//  Rappeliculas
//
//  Created by Alejandro Agudelo on 30/10/18.
//  Copyright © 2018 Alejandro Agudelo. All rights reserved.
//

//import CoreData
import UIKit
import RevealingSplashView

class PopularTVC: UITableViewController {
    var servicios = Servicios()
    var peliculas = [PeliculaCD]()
    var dataController: DataController!

    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.dataController.persistentContainer.persistentStoreDescriptions)
    }
    
    
    func cargarPeliculas() {
        if let resultado = servicios.fetchPopularMovies(dataController: dataController) {
            peliculas = resultado
        }
        tableView.reloadData()
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return peliculas.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath)

        cell.textLabel?.text = peliculas[indexPath.row].title ?? ""

        return cell
    }
    
 

    
     // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verDetalle" {
            let vc = segue.destination as! DetallePeliculaVC
            let indiceSeleccionado = tableView.indexPathForSelectedRow?.row
            vc.titulo = peliculas[indiceSeleccionado!].title!
            vc.fecha = peliculas[indiceSeleccionado!].release_date!
            vc.resumen = peliculas[indiceSeleccionado!].overview!
        }
    
     }
    
}
