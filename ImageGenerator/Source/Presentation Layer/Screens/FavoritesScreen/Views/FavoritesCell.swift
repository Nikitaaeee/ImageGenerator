//
//  FavoritesCell.swift
//  ImageGenerator
//
//  Created by Nikita Kirshin on 03.05.2023.
//

import UIKit

final class FavoritesCell: UITableViewCell {
    
    // MARK: - Properties
    
    static var identifier: String {
        "\(type(of: self))"
    }
    
    //MARK: - Views
    
    private let cellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Public Methods
    
    func configure(with viewModel: GeneratedImageModel) {
        guard let image = UIImage(data: viewModel.image) else { return }
        addSubviews()
        configureConstraints()
        cellImageView.image = image
        titleLabel.text = viewModel.queryString
    }
}

//MARK: - Private

extension FavoritesCell {
    func addSubviews() {
        contentView.addSubview(cellImageView)
        contentView.addSubview(titleLabel)
    }
    
    func configureConstraints() {
        let marginGuide = contentView.layoutMarginsGuide
        let imageHeight: CGFloat = Constants.imageHeight
        let horizontalPadding: CGFloat = Constants.horizontalPadding
        let verticalPadding: CGFloat = Constants.verticalPadding
        
        NSLayoutConstraint.activate([
            cellImageView.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: verticalPadding),
            cellImageView.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor, constant: horizontalPadding),
            cellImageView.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor, constant: -verticalPadding),
            cellImageView.widthAnchor.constraint(equalToConstant: imageHeight),
            
            titleLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: verticalPadding),
            titleLabel.leadingAnchor.constraint(equalTo: cellImageView.trailingAnchor, constant: horizontalPadding),
            titleLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor, constant: -horizontalPadding),
            titleLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor, constant: -verticalPadding)
        ])
    }
}

//MARK: - Constraints

private extension FavoritesCell {
    enum Constants {
        static let imageHeight: CGFloat = 60
        static let horizontalPadding: CGFloat = 16
        static let verticalPadding: CGFloat = 8
    }
}
