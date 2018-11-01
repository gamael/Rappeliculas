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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Initialize a revealing Splash with with the iconImage, the initial size and the background color
        let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "ICtmdb")!, iconInitialSize: CGSize(width: 147, height: 151), backgroundColor: UIColor(red: 255, green: 255, blue: 255, alpha: 1.0))

        // Adds the revealing splash view as a sub view
        view.addSubview(revealingSplashView)

        // Starts animation
        revealingSplashView.startAnimation()

        // Do any additional setup after loading the view.
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
