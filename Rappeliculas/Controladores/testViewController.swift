//
//  testViewController.swift
//  Rappeliculas
//
//  Created by Alejandro Agudelo on 1/11/18.
//  Copyright © 2018 Alejandro Agudelo. All rights reserved.
//

import UIKit
import CoreData
import Cards

class testViewController: UIViewController {
    
    var peliculas = [PeliculaCD]()
    var dataController: DataController!
    @IBOutlet var scrollview: UIScrollView!
    @IBOutlet var stack: UIStackView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let fetchRequest: NSFetchRequest<PeliculaCD> = PeliculaCD.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let resultado = try? dataController.viewContext.fetch(fetchRequest) {
            peliculas = resultado
            pintarcosas()
                
            
        }

        // Do any additional setup after loading the view.
    }
    
    
    func pintarcosas() -> Void {
        print(peliculas.count)
        for i in 0...2 {
            let card = CardHighlight(frame: CGRect(x: 10, y: 30, width: 200 , height: 240))
            
            card.backgroundColor = UIColor(red: 0, green: 94/255, blue: 112/255, alpha: 1)
            card.icon = UIImage(named: "flappy")
            card.title = "Welcome \nto \nCards !"
            card.itemTitle = "Flappy Bird"
            card.itemSubtitle = "Flap That !"
            card.textColor = UIColor.white
            
            card.hasParallax = true
            card.translatesAutoresizingMaskIntoConstraints = false
//            let cardContentVC = storyboard!.instantiateViewController(withIdentifier: "CardContent")
//            card.shouldPresent(cardContentVC, from: self, fullscreen: false)
            
            stack.addArrangedSubview(card)
            NSLayoutConstraint.activate([
//                card.centerXAnchor.constraint(equalTo: scrollview.centerXAnchor),
//                card.topAnchor.constraint(equalTo: scrollview.topAnchor, constant: (CGFloat(i*250))),
                card.widthAnchor.constraint(equalToConstant: 200),
                card.heightAnchor.constraint(equalToConstant: 240)
                ])

        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
