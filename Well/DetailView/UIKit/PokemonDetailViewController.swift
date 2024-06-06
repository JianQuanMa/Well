//
//  PokemonDetailViewController.swift
//  Well
//
//  Created by Jian Ma on 6/5/24.
//

import UIKit

class PokemonDetailViewController: UIViewController {
    typealias Model = Pokemon
    
    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    var _configure: (Model, ImageClient)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let (model, imageClient) = _configure {
            title = model.name
            subtitleLabel.text = model.description
            
            imageClient.fetch(model.imageUrl) { [weak self] image in
                self?.pokemonImageView.image = image
            }.resume()
        }
    }
}
