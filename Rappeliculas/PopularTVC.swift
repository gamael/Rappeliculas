//
//  PopularTVC.swift
//  Rappeliculas
//
//  Created by Alejandro Agudelo on 30/10/18.
//  Copyright © 2018 Alejandro Agudelo. All rights reserved.
//

import UIKit
import CoreData

class PopularTVC: UITableViewController {
    
    var servicios = Servicios()
    var peliculas = [PeliculaCD]()
    var dataController: DataController!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let fetchRequest:NSFetchRequest<PeliculaCD> = PeliculaCD.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let resultado = try? dataController.viewContext.fetch(fetchRequest) {
            peliculas = resultado
        }
        if peliculas.count == 0 {
            servicios.getPopularMovies() { resultado in
                self.servicios.savePupularMovies(resultado, dataController: self.dataController, completion: {
                    print("se supone grabado")
                    print(self.dataController.persistentContainer.persistentStoreDescriptions)
                    
                    })
            }
        }
        
        
        
        
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peliculas.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath)

        cell.textLabel?.text = peliculas[indexPath.row].title ?? ""

        return cell
    }
 

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
