//
//  Servicios.swift
//  Rappeliculas
//
//  Created by Alejandro Agudelo on 29/10/18.
//  Copyright © 2018 Alejandro Agudelo. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Servicios {
    
    func getPopularMovies(completion: @escaping ([Pelicula]) -> Void )  {
        let parametros: Parameters = [
            "api_key" : Registro.conexionIMDB.apiKey,
            "language" : Registro.configuración.idiomaPorDefecto,
            "page" : "1"
        ]
        Alamofire.request("\(Registro.conexionIMDB.URLservicio)movie/top_rated", parameters: parametros).responseJSON { response in
            
            switch response.result {
            case .success:
                do {
                    let json = try JSON(data: response.data!)
                    let peliculasResultado: [Pelicula] = try [Pelicula].decode(from: json["results"].rawData())
                    completion(peliculasResultado)
                }catch {
                    print("El servicio falló")
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func savePupularMovies(_ peliculas: [Pelicula], dataController dc: DataController, completion: @escaping () -> () ) -> Void {
        for peli in peliculas {
            let peliculaCoreData = PeliculaCD(context: dc.viewContext)
            peliculaCoreData.poster_path = peli.poster_path
            peliculaCoreData.adult = peli.adult
            peliculaCoreData.overview = peli.overview
            peliculaCoreData.release_date = peli.release_date
            peliculaCoreData.original_title = peli.original_title
            peliculaCoreData.original_language = peli.original_language
            peliculaCoreData.backdrop_path = peli.backdrop_path
            peliculaCoreData.popularity = peli.popularity
            peliculaCoreData.vote_count = peli.vote_count
            peliculaCoreData.video = peli.video
            peliculaCoreData.vote_average = peli.vote_average
            peliculaCoreData.id = peli.id
            peliculaCoreData.title = peli.title
        }
        try? dc.viewContext.save()
        completion()
    }
    
}
