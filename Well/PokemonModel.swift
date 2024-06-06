//
//  PokemonModel.swift
//  Well
//
//  Created by Jian Ma on 6/5/24.
//

import Foundation

struct Pokemon: Identifiable, Decodable, Hashable, Equatable {
    let id: Int
    let name: String
    let description: String
    let imageUrl: URL
}
