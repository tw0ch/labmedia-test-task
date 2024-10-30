//
//  PokemonTableViewCell.swift
//  TestLabmedia
//
//  Created by Егор Мизюлин on 27.10.2024.
//

import UIKit

class PokemonTableViewCell: UITableViewCell {
    static let cellID: String = "PokemonTableViewCell"

    private let pokemonImage: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()

    private let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.font = .systemFont(ofSize: 18, weight: .semibold)
        return lbl
    }()

    private let numLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.font = .systemFont(ofSize: 12, weight: .regular)
        return lbl
    }()

    private var currentImageURL: URL?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init?(coder:) has not been implementer")
    }

    func setupCell() {
        for item in [pokemonImage, nameLabel, numLabel] {
            item.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(item)
        }

        NSLayoutConstraint.activate([
            pokemonImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            pokemonImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            pokemonImage.heightAnchor.constraint(equalToConstant: 50),
            pokemonImage.widthAnchor.constraint(equalToConstant: 50),

            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: pokemonImage.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            numLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            numLabel.leadingAnchor.constraint(equalTo: pokemonImage.trailingAnchor, constant: 16),
            numLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
        ])
    }

    func configure(with pokemon: Pokemon) {
        nameLabel.text = pokemon.name.capitalizingFirstWord()
        numLabel.text = String(format: "#%03d", pokemon.id)

        if let imageUrl = URL(string: pokemon.sprites.other.officialArtwork.frontDefault) {
            currentImageURL = imageUrl
            loadImage(from: imageUrl)
        } else {
            pokemonImage.image = nil
        }
    }

    private func loadImage(from url: URL) {
        pokemonImage.image = nil

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self, let data = data, error == nil else { return }

            if url == self.currentImageURL {
                DispatchQueue.main.async {
                    self.pokemonImage.image = UIImage(data: data)
                }
            }
        }.resume()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        pokemonImage.image = nil
        currentImageURL = nil
    }
}
