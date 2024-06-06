//
//  SwiftUIView.swift
//  Well
//
//  Created by Jian Ma on 6/5/24.
//

import SwiftUI

struct PokemonDetailView: View {
    let pokemon: Pokemon

    var body: some View {
        VStack {
            AsyncImage(url: pokemon.imageUrl)
            
            Text(pokemon.description)
                .font(.subheadline)
            Spacer()
        }
        .padding(.horizontal, 16)
        .navigationTitle(pokemon.name)
    }
}
