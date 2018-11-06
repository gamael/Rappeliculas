//
//  TabBarController.swift
//  Rappeliculas
//
//  Created by Alejandro Agudelo on 1/11/18.
//  Copyright © 2018 Alejandro Agudelo. All rights reserved.
//

import RevealingSplashView
import UIKit


class TabBarController: UITabBarController {
    
    var servicios = Servicios()
    var dataController: DataController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("root did load")
        loadingAnimation()
        definesPresentationContext = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("Root viewWillDisappear")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Root viewWillAppear")
    }
    
    fileprivate func loadingAnimation() {
        let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "ICtmdb")!, iconInitialSize: CGSize(width: 147, height: 151), backgroundColor: UIColor(red: 255, green: 255, blue: 255, alpha: 1.0))
        
        // Adds the revealing splash view as a sub view
        view.addSubview(revealingSplashView)
        
        revealingSplashView.animationType = .heartBeat
        
        // Starts animation
        revealingSplashView.startAnimation()
        
        if servicios.existenPeliculas(dataController: dataController) {
            let vc = self.childViewControllers.first as! PopularTVC
            vc.cargarPeliculas()
            revealingSplashView.heartAttack = true
        } else {
            servicios.getPopularMovies(completion: {popularMovies in
                self.servicios.savePupularMovies(popularMovies, dataController: self.dataController, completion: {
                    let vc = self.childViewControllers.first as! PopularTVC
                    vc.cargarPeliculas()
                    DispatchQueue.main.async {
                        revealingSplashView.heartAttack = true
                    }
                    })
                
            })
        }
        
    }

}
