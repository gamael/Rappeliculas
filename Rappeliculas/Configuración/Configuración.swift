//
//  Configuración.swift
//  Rappeliculas
//
//  Created by Alejandro Agudelo on 28/10/18.
//  Copyright © 2018 Alejandro Agudelo. All rights reserved.
//

import Foundation

struct Registro {
    private init() {}
    struct conexionIMDB {
        static let URLservicio = "https://api.themoviedb.org/3/"
        static let URLimagenes = "http://image.tmdb.org/t/p/"
        static let apiKey = "6f76b5b149d80e160c9cff7e4093856e"
        static let tamañoImagen = "w342"
    }

    struct configuración {
        static let idiomaPorDefecto = "es-CO"
    }
}
