//
//  FavoritesInteractor.swift
//  ImageGenerator
//
//  Created by Nikita Kirshin on 03.05.2023.
//

import Foundation

protocol FavoritesBussinesLogic {
    func fetchData()
    func deleteGeneratedImage(with request: FavoritesDataFlow.Request)
}

final class FavoritesInteractor {

    //MARK: - Properties
    
    private var presenter: FavoritesPresentationLogic
    private var provider: FavoritesProviderProtocol
    
    init(presenter: FavoritesPresentationLogic,
         provider: FavoritesProviderProtocol) {
        self.presenter = presenter
        self.provider = provider
    }
}

//MARK: - FavoritesBussinesLogic

extension FavoritesInteractor: FavoritesBussinesLogic {
    func fetchData() {
        provider.fetchImageData { result in
            switch result {
            case .success(let model):
                self.presenter.presentData(with: FavoritesDataFlow.Response(cells: model))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteGeneratedImage(with request: FavoritesDataFlow.Request) {
        provider.deleteGeneratedImage(with: request)
    }
}


