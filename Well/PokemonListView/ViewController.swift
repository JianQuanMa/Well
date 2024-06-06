//
//  ViewController.swift
//  Well
//
//  Created by Jian Ma on 6/5/24.
//

import UIKit
import Combine

final class ViewController: UIViewController {
    typealias ViewModel = HomeScreenViewModel
    
    private let viewModel: ViewModel
    let imageClient: ImageClient
    
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero)
        let nib = UINib(nibName: PokemonCellViewTableViewCell.nibName, bundle: nil)

        tv.delegate = self
        tv.dataSource = self
        tv.register(nib, forCellReuseIdentifier: PokemonCellViewTableViewCell.reuseId)

        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        
        style(navigationController)
        
        title = viewModel.title
        
        viewModel.onViewDidLoad()
    }
    

    init(viewModel: ViewController.ViewModel, imageClient: ImageClient) {
        self.viewModel = viewModel
        self.imageClient = imageClient
        super.init(nibName: nil, bundle: nil)
        
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var cancellable: AnyCancellable?
    
    var pokemonFetchState: ViewModel.FetchState = .idle

    private func bind() {
        cancellable = viewModel.$fetchState.sink { [weak self] in
            self?.pokemonFetchState = $0
            self?.tableView.reloadData()
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch pokemonFetchState {
        case .idle,
                .loading(_),
                .loaded(.failure):
            return 0
        case .loaded(.success(let pokemon)):
            return pokemon.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PokemonCellViewTableViewCell.reuseId, for: indexPath) as? PokemonCellViewTableViewCell else {
            fatalError()
        }
        
        
        switch viewModel.fetchState {
        case .loaded(.success(let pokemons)):
            cell.configure(
                with: pokemons[indexPath.row],
                imageClient: imageClient
            )
            break
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch viewModel.fetchState {
        case .loaded(.success(let pokemons)):
            let selectedPokemon = pokemons[indexPath.row]
            let myViewController = PokemonDetailViewController(nibName: "PokemonDetailViewController", bundle: nil)

            myViewController._configure = (selectedPokemon, imageClient)
            self.navigationController?.pushViewController(myViewController, animated: true)
        default:
            break
        }
    }
    
}

