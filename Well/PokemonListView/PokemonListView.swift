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
        .onAppear {
            viewModel.onAppear()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(viewModel.title)
        .navigationBarColor(UIColor(hex: "#5856d6"), titleColor: UIColor.black)
    }
    
    private func pokemonCell(pokemon: Pokemon) -> some View {
        HStack {
            AsyncImage(url: pokemon.imageUrl) { image in
                image

                    .resizable()
                    .scaledToFit()
                    .frame(width: 80)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 48)
            .padding(.trailing, 8)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(pokemon.name)
                    .font(.body)
                    .bold()
                Text(pokemon.description)
                    .font(.body)
            }
            .padding(.vertical, 8)
        }
        .listRowInsets(EdgeInsets())
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

import SwiftUI
import UIKit

struct NavigationBarColorModifier: UIViewControllerRepresentable {
    var backgroundColor: UIColor
    var titleColor: UIColor

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        
        DispatchQueue.main.async {
            if let navigationController = viewController.navigationController {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = backgroundColor
                appearance.titleTextAttributes = [.foregroundColor: titleColor]
                appearance.largeTitleTextAttributes = [.foregroundColor: titleColor]

                navigationController.navigationBar.standardAppearance = appearance
                navigationController.navigationBar.scrollEdgeAppearance = appearance
            }
        }
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        DispatchQueue.main.async {
            if let navigationController = uiViewController.navigationController {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = backgroundColor
                appearance.titleTextAttributes = [.foregroundColor: titleColor]
                appearance.largeTitleTextAttributes = [.foregroundColor: titleColor]

                navigationController.navigationBar.standardAppearance = appearance
                navigationController.navigationBar.scrollEdgeAppearance = appearance
            }
        }
    }
}

extension View {
    func navigationBarColor(_ backgroundColor: UIColor, titleColor: UIColor = .black) -> some View {
        self.background(NavigationBarColorModifier(backgroundColor: backgroundColor, titleColor: titleColor))
    }
}
