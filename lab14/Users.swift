//
//  Users.swift
//  lab14
//
//  Created by Juan E. M. on 21/06/23.
//

import Foundation

struct Users:Decodable {
    let id:Int
    let nombre:String
    let clave:String
    let email: String
}
