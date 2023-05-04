//
//  MainPageViewController.swift
//  ImageGenerator
//
//  Created by Nikita Kirshin on 02.05.2023.
//

import UIKit

protocol MainPageDisplayLogic: AnyObject {
    func configure(with viewModel: MainPageDataFlow.ViewModel)
    func configureImage(with viewModel: MainPageDataFlow.PresentGeneratedImageFlow.ViewModel)
    func configureAddedToFavorites(with viewModel: MainPageDataFlow.AlertFlow.ViewModel)
    func configureErrorAlert(with viewModel: MainPageDataFlow.AlertFlow.ViewModel)
}

final class MainPageViewController: UIViewController {
    
    //MARK: - Properties
    
    private var interactor: MainPageBussinesLogic
    private var contentView: DisplaysMainPage = MainPageView()
    private var router: MainPageRoutes

    //MARK: - Lifecycle
    
    init(interactor: MainPageBussinesLogic,
         router: MainPageRoutes) {
        self.interactor = interactor
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.delegate = self
        interactor.fetchData()
    }
}

//MARK: - MainPageDisplayLogic

extension MainPageViewController: MainPageDisplayLogic {
    func configure(with viewModel: MainPageDataFlow.ViewModel) {
        var viewModel = viewModel
        viewModel.generateImageButtonModel.buttonTapHandler = { [weak self] in
            guard let self = self else { return }
            interactor.fetchImage(request: MainPageDataFlow.Request(requestString: self.contentView.getQueryText()))
        }
        
        viewModel.addToFavoritesButtonModel.buttonTapHandler = { [weak self] in
            guard let self = self else { return }
            contentView.favoritesButtonTapped()
        }
        contentView.configure(with: viewModel)
    }
    
    func configureImage(with viewModel: MainPageDataFlow.PresentGeneratedImageFlow.ViewModel) {
        contentView.configureImage(with: viewModel)
    }
    
    func configureAddedToFavorites(with viewModel: MainPageDataFlow.AlertFlow.ViewModel) {
        router.showAlert(with: viewModel)
        contentView.changeFavoriteImageState()
    }
    
    func configureErrorAlert(with viewModel: MainPageDataFlow.AlertFlow.ViewModel) {
        router.showAlert(with: viewModel)
    }
}

//MARK: - MainPageViewDelegate

extension MainPageViewController: MainPageViewDelegate {
    func saveImageModelToFavorites(model: GeneratedImageModel) {
        let model = GeneratedImageModel(image: model.image, queryString: model.queryString, dateCreated: model.dateCreated)
        interactor.saveImageToFavorites(model: MainPageDataFlow.AlertFlow.Request(model: model))
    }
    
    func getQueryText(text: String) {
        interactor.fetchImage(request: MainPageDataFlow.Request(requestString: text))
    }
}
