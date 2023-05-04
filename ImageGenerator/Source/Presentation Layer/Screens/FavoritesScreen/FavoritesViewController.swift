//
//  FavoritesViewController.swift
//  ImageGenerator
//
//  Created by Nikita Kirshin on 03.05.2023.
//

import UIKit

protocol FavoritesDisplayLogic: AnyObject {
    func configure(with viewModel: FavoritesDataFlow.ViewModel)
}

final class FavoritesViewController: UIViewController {
    
    //MARK: - Properties
    
    private var interactor: FavoritesBussinesLogic
    private var contentView: DisplaysFavorites = FavoritesView(tableManager: FavoritesTableViewManager())

    //MARK: - Lifecycle
    
    init(interactor: FavoritesBussinesLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
        contentView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor.fetchData()
    }
}

//MARK: - FavoritesDisplayLogic

extension FavoritesViewController: FavoritesDisplayLogic {
    func configure(with viewModel: FavoritesDataFlow.ViewModel) {
        contentView.configure(with: viewModel)
    }
}

//MARK: - FavoritesViewDelegate

extension FavoritesViewController: FavoritesViewDelegate {
    func deleteCell(with model: GeneratedImageModel) {
        interactor.deleteGeneratedImage(with: FavoritesDataFlow.Request(model: model))
    }
    
    
}
