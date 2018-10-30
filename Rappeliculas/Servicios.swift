//
//  Servicios.swift
//  Rappeliculas
//
//  Created by Alejandro Agudelo on 29/10/18.
//  Copyright © 2018 Alejandro Agudelo. All rights reserved.
//

import Foundation
import Alamofire

class Servicios {
    
    func getPopularMovies()  {
        let parametros: Parameters = [
            "api_key" : Registro.conexionIMDB.apiKey,
            "language" : Registro.configuración.idiomaPorDefecto,
            "page" : "1"
        ]
//        let parameters: Parameters = ["foo": "bar"]
        Alamofire.request("\(Registro.conexionIMDB.URLservicio)movie/top_rated", parameters: parametros).responseJSON { response in
            debugPrint(response)
            
            if let json = response.result.value {
                print("JSON: \(json)")
            }
            
            switch response.result {
            case .success:
                print("Validation Successful")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
}
