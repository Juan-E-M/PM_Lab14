//
//  Peliculas.swift
//  lab14
//
//  Created by Juan E. M. on 21/06/23.
//

import Foundation

struct Peliculas: Decodable {
    let usuarioId: Int
    let id: Int
    let nombre: String
    let genero: String
    let duracion: String
}
