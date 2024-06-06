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
    @IBOutlet weak private(set) var pokemonImageView: UIImageView! {
        didSet {
            pokemonImageView.backgroundColor = .green
        }
    }
    
    private var task: URLSessionDataTask?

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .green
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
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        print("-=- \(Self.self).\(#function)")
//    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.task?.cancel()
        self.task = nil
        pokemonImageView.image = nil
    }
}

private let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
private let lettersLength = UInt32(letters.count)
func randomString(length: Int) -> String {
    var result = ""

    for _ in 0..<length {
        let randomIndex = Int(arc4random_uniform(lettersLength))
        let randomCharacter = letters[letters.index(letters.startIndex, offsetBy: randomIndex)]
        result.append(randomCharacter)
    }
    return result
}
