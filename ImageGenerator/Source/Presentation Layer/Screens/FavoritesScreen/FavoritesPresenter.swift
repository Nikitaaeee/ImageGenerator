//
//  FavoritesPresenter.swift
//  ImageGenerator
//
//  Created by Nikita Kirshin on 03.05.2023.
//

import Foundation

protocol FavoritesPresentationLogic: AnyObject {
    func presentData(with response: FavoritesDataFlow.Response)
}

final class FavoritesPresenter {
    
    //MARK: - Properties
    
    weak var viewController: FavoritesDisplayLogic?
}

extension FavoritesPresenter: FavoritesPresentationLogic {
    func presentData(with response: FavoritesDataFlow.Response) {
        viewController?.configure(with: makeViewModel(from: response))
    }
}

//MARK: - Private

private extension FavoritesPresenter {
    func makeViewModel(from response: FavoritesDataFlow.Response) -> FavoritesDataFlow.ViewModel {
        let sortedCells = response.cells.sorted(by: { $0.dateCreated > $1.dateCreated })
        
        return FavoritesDataFlow.ViewModel(cells: sortedCells)
    }
}
