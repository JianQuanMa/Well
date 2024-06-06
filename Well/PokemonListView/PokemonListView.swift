//
//  PokemonListView.swift
//  Well
//
//  Created by Jian Ma on 6/5/24.
//
import SwiftUI

struct PokemonListView: View {
    typealias ViewModel = HomeScreenViewModel
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        ScrollView {
            switch viewModel.fetchState {
            case .idle:
                EmptyView()
            case .loaded(.success(let pokemon)):
                VStack(alignment: .leading) {
                    ForEach(pokemon, id: \.self) { pokemon in
                        
                        NavigationLink(
                            destination: PokemonDetailView(pokemon: pokemon),
                            label: {
                                pokemonCell(pokemon: pokemon)
                                    .foregroundStyle(.primary)
                            }
                        )
                        .buttonStyle(PlainButtonStyle())
                    }
                }

            case .loaded(.failure(let error)):
                Text(error.localizedDescription)

            case .loading(let title):
                HStack {
                    Text(title)
                    ProgressView()
                }
            }
        }
        .padding()
        .background(.red)
        .onAppear {
            viewModel.onAppear()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.blue)
        .toolbarColorScheme(.dark)
        .navigationTitle(viewModel.title)
    }
    
    private func pokemonCell(pokemon: Pokemon) -> some View {
        HStack {
            AsyncImage(url: pokemon.imageUrl) { image in
                image

                    .resizable()
                    .scaledToFit()
                
            } placeholder: {
                ProgressView()
            }
            .background(.yellow)
            .frame(width: 48)
            .padding(.trailing, 8)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(pokemon.name)
                    .font(.title)
                Text(pokemon.description)
                    .font(.subheadline)
            }
            .padding(.vertical, 8)
        }
        .listRowInsets(EdgeInsets())
        .background(.red)
    }
}

#Preview {
    NavigationStack  {
        PokemonListView(
            viewModel: .init(
                client:
                    
                        .live(session: .shared, extraDelay: .zero)
            )
        )
    }
}

