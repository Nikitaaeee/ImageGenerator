//
//  DefaultButton.swift
//  ImageGenerator
//
//  Created by Nikita Kirshin on 02.05.2023.
//

import UIKit

protocol DefaultButtonConfigurable: UIControl {
    func configure(with viewModel: DefaultButtonModel)
}

final class DefaultButton: UIControl {
    typealias SelectionHandler = () -> Void
    
    // MARK: - Properties
    
    private var selectHandler: SelectionHandler?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = Constants.buttonNumberOfLines
        label.textAlignment = .center
        
        return label
    }()
    
    // MARK: - Lifecycle
    
    init() {
        super.init(frame: .zero)
        self.addSubviews()
        self.setupButtonGesture()
        self.setupCornerRadius()
        self.makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - DefaultButtonConfigurable

extension DefaultButton: DefaultButtonConfigurable {
    func configure(with viewModel: DefaultButtonModel) {
        self.titleLabel.text = viewModel.title
        self.titleLabel.textColor = viewModel.titleColor
        self.backgroundColor = viewModel.buttonColor
        self.selectHandler = viewModel.buttonTapHandler
        if viewModel.font != nil {
            titleLabel.font = viewModel.font
        }
    }
}


// MARK: - Private

private extension DefaultButton {
    func setupButtonGesture() {
        let gestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(self.buttonDidTap))
        self.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc
    func buttonDidTap() {
        self.selectHandler?()
    }
    
    func setupCornerRadius() {
        self.layer.cornerRadius = Constants.cornerRadius
    }
    
    func addSubviews() {
        self.addSubview(titleLabel)
    }
    
    func makeConstraints() {
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    func setupBorder() {
        self.layer.borderWidth = Constants.borderWidth
    }
}

    // MARK: - Constants

private extension DefaultButton {
    enum Constants {
        static let buttonNumberOfLines: Int = 1
        static let buttonAnimationDuration: Double = 0.15
        static let cornerRadius: CGFloat = 4
        static let borderWidth: CGFloat = 1
    }
}
