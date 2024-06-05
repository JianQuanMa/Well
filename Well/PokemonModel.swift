//
//  PokemonModel.swift
//  Well
//
//  Created by Jian Ma on 6/5/24.
//

import Foundation

struct Pokemon: Identifiable, Decodable, Hashable {
    let id: Int
    let name: String
    let description: String
    let imageURl: URL
}
