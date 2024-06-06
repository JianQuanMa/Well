//
//  PokemonCellViewTableViewCell.swift
//  Well
//
//  Created by Jian Ma on 6/5/24.
//

import UIKit

class PokemonCellViewTableViewCell: UITableViewCell {
    typealias Model = Pokemon

    static var reuseId: String { "\(Self.self)" }
    static var nibName: String { reuseId }
    
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak private(set) var pokemonImageView: UIImageView!
    
    private var task: URLSessionDataTask?

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    
    func configure(with model: Model, imageClient: ImageClient) {
        titleLabel.text = model.name
        subtitleLabel.text = model.description
        
        task = imageClient.fetch(model.imageUrl) { [weak self] in
            self?.pokemonImageView.image = $0
        }

        task?.resume()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.task?.cancel()
        self.task = nil
        pokemonImageView.image = nil
    }
}
