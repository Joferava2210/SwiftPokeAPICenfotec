//
//  PokemonResult.swift
//  SwiftPokeAPI
//
//  Created by Felipe Ramirez Vargas on 4/3/21.
//

import Foundation

struct Root : Codable {
    let next : String
    let results : [Pokemon]
}

struct Pokemon: Codable {
    let name: String;
    let url: String;
}


