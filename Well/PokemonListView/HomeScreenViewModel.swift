//
//  HomeScreenViewModel.swift
//  Well
//
//  Created by Jian Ma on 6/5/24.
//

import Foundation

@MainActor
final class HomeScreenViewModel: ObservableObject {
    let title = "Pokémon"
    enum FetchState {
        case idle
        case loading(String)
        case loaded(Result<[Pokemon], Error>)
    }
    
    @Published var fetchState = FetchState.idle
    
    private var loadTask: Task<Void, Never>?
    
    let client: PokemonsClient
    
    init(fetchState: HomeScreenViewModel.FetchState = FetchState.idle, client: PokemonsClient) {
        self.fetchState = fetchState
        self.client = client
    }
    
    // UIKit
    func onViewDidLoad() {
        loadPokemons()
    }
    
    //swiftUI
    func onAppear() {
        loadPokemons()
    }
    
    private func loadPokemons() {
        loadTask = Task {
            fetchState = .loading("loading")
            fetchState = .loaded(await client.fetch())
        }
    }
}


