//
//  MainPageInteractor.swift
//  ImageGenerator
//
//  Created by Nikita Kirshin on 02.05.2023.
//

import Foundation

protocol MainPageBussinesLogic {
    func fetchData()
    func fetchImage(request: MainPageDataFlow.Request)
    func saveImageToFavorites(model: MainPageDataFlow.AlertFlow.Request)
}

final class MainPageInteractor {
    
    //MARK: - Properties
    
    private var presenter: MainPagePresentationLogic
    private var provider: MainPageProviderProtocol
    
    //MARK: - Lifecycle

    init(presenter: MainPagePresentationLogic, provider: MainPageProviderProtocol) {
        self.presenter = presenter
        self.provider = provider
    }
}

//MARK: - MainPageBussinesLogic

extension MainPageInteractor: MainPageBussinesLogic {
    func fetchData() {
        presenter.presentInitialData()
    }
    
    func fetchImage(request: MainPageDataFlow.Request) {
        provider.fetchImageData(queryString: request) { result in
            switch result {
            case .success(let data):
                guard let data = data else { return }
                self.presenter.presentImage(response: MainPageDataFlow.PresentGeneratedImageFlow.Response(imageData: data))
                
            case .failure(let error):
                self.presenter.presentNetworkError(with: error)
            }
        }
    }
    
    func saveImageToFavorites(model: MainPageDataFlow.AlertFlow.Request) {
        provider.saveImageToFavorites(model: model) { result in
            switch result {
            case .success():
                self.presenter.presentAddedToFavorites()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
