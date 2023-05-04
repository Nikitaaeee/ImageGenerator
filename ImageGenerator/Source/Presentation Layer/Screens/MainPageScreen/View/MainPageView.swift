//
//  MainPageView.swift
//  ImageGenerator
//
//  Created by Nikita Kirshin on 02.05.2023.
//

import UIKit

protocol DisplaysMainPage: UIView {
    func configure(with viewModel: MainPageDataFlow.ViewModel)
    func configureImage(with viewModel: MainPageDataFlow.PresentGeneratedImageFlow.ViewModel)
    func changeFavoriteImageState()
    var delegate: MainPageViewDelegate? { get set }
    func getQueryText() -> String
    func favoritesButtonTapped()
}

protocol MainPageViewDelegate: AnyObject {
    func saveImageModelToFavorites(model: GeneratedImageModel)
}

final class MainPageView: UIView {
    
    //MARK: - Properties
    
    weak var delegate: MainPageViewDelegate?
    private var isGeneratedImage: Bool = false
    
    //MARK: - Views
    
    private lazy var queryTextField: QueryTextField = QueryTextField()
    private lazy var generateImageButton: DefaultButtonConfigurable = DefaultButton()
    private lazy var addToFavoritesButton: DefaultButtonConfigurable = DefaultButton()
    
    private var generatedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Constants.defaultImageName)
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.titleLabelText
        
        return label
    }()
    
    //MARK: - Lifecycle
    
    init() {
        super.init(frame: .zero)
        queryTextField.delegate = self
        addSubviews()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func favoritesButtonTapped() {
        guard let imageData = generatedImageView.image?.pngData(),
              let text = queryTextField.text else { return }
        let model = GeneratedImageModel(
            image: imageData,
            queryString: text,
            dateCreated: Date())
        delegate?.saveImageModelToFavorites(model: model)
        changeFavoriteImageState()
    }
}

//MARK: - DisplaysMainPage

extension MainPageView: DisplaysMainPage {
    func configure(with viewModel: MainPageDataFlow.ViewModel) {
        self.backgroundColor = .white
        self.generateImageButton.configure(with: viewModel.generateImageButtonModel)
        self.addToFavoritesButton.configure(with: viewModel.addToFavoritesButtonModel)
        self.addToFavoritesButton.isHidden = true
    }
    
    func configureImage(with viewModel: MainPageDataFlow.PresentGeneratedImageFlow.ViewModel) {
        guard let image = UIImage(data: viewModel.imageData) else { return }
        self.generatedImageView.image = image
        self.isGeneratedImage = true
        self.addToFavoritesButton.isHidden = false
        self.addToFavoritesButton.isEnabled = true
        self.addToFavoritesButton.backgroundColor = .systemGreen
    }
    
    func changeFavoriteImageState() {
        if !addToFavoritesButton.isHidden {
            addToFavoritesButton.backgroundColor = .lightGray
            addToFavoritesButton.isEnabled = false
        }
    }
    
    func getQueryText() -> String {
        guard let text = queryTextField.text else { return "" }
        return replaceSpacesWithPluses(input: text)
    }
}

//MARK: - UITextFieldDelegate

extension MainPageView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {        
        textField.resignFirstResponder()
        
        return true
    }
}

//MARK: - Private

private extension MainPageView {
    func addSubviews() {
        self.addSubview(generatedImageView)
        self.addSubview(titleLabel)
        self.addSubview(queryTextField)
        self.addSubview(generateImageButton)
        self.addSubview(addToFavoritesButton)
    }
    
    func configureConstraints() {
        configureGeneratedImageViewConstraints()
        configureTitleLabelConstraints()
        configureTextFieldConstraints()
        configureConfirmButtonConstraints()
        configureAddToFavoritesButtonConstraints()
    }
    
    func configureGeneratedImageViewConstraints() {
        self.generatedImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.generatedImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.generatedImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.imageTopOffset),
            self.generatedImageView.widthAnchor.constraint(equalToConstant: Constants.imageSize),
            self.generatedImageView.heightAnchor.constraint(equalToConstant: Constants.imageSize)
        ])
    }
    
    func configureTitleLabelConstraints() {
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.sideOffset),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: Constants.sideOffset.negative),
            self.titleLabel.heightAnchor.constraint(equalToConstant: Constants.labelHeight),
            self.titleLabel.topAnchor.constraint(equalTo: self.generatedImageView.bottomAnchor, constant: Constants.mediumOffset)
        ])
    }
    
    func configureTextFieldConstraints() {
        self.queryTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.queryTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.sideOffset),
            self.queryTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: Constants.sideOffset.negative),
            self.queryTextField.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            self.queryTextField.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: Constants.smallOffset)
        ])
    }
    
    func configureConfirmButtonConstraints() {
        self.generateImageButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.generateImageButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.sideOffset),
            self.generateImageButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: Constants.sideOffset.negative),
            self.generateImageButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            self.generateImageButton.topAnchor.constraint(equalTo: self.queryTextField.bottomAnchor, constant: Constants.mediumOffset)
        ])
    }
    
    func configureAddToFavoritesButtonConstraints() {
        self.addToFavoritesButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.addToFavoritesButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.sideOffset),
            self.addToFavoritesButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: Constants.sideOffset.negative),
            self.addToFavoritesButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            self.addToFavoritesButton.topAnchor.constraint(equalTo: self.generateImageButton.bottomAnchor, constant: Constants.smallOffset)
        ])
    }
    
    func replaceSpacesWithPluses(input: String) -> String {
        let result = input.replacingOccurrences(of: " ", with: "+")
        
        return result
    }
}

//MARK: - Constants

private extension MainPageView {
    enum Constants {
        static let sideOffset: CGFloat = 44
        static let imageTopOffset: CGFloat = 80
        static let imageSize: CGFloat = 200
        static let defaultImageName: String = "defaultImage"
        static let titleLabelText: String = "Сгенерируйте изображение:"
        static let favoriteImageName: String = "star"
        static let buttonBottomOffset: CGFloat = 100
        static let buttonHeight: CGFloat = 50
        static let labelHeight: CGFloat = 24
        static let mediumOffset: CGFloat = 24
        static let smallOffset: CGFloat = 12
        static let favoriteImageSize: CGFloat = 34
    }
}
