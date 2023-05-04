//
//  MainPageProvider.swift
//  ImageGenerator
//
//  Created by Nikita Kirshin on 03.05.2023.
//

import Foundation

protocol MainPageProviderProtocol {
    func fetchImageData(queryString: MainPageDataFlow.Request, completion: @escaping (RequestResult<Data>))
    func saveImageToFavorites(model: MainPageDataFlow.AlertFlow.Request, completion: @escaping (Result<Void, Error>) -> Void)
}

final class MainScreenProvider {
    
    //MARK: - Properties
    private var networkManager: MainScreenNetworkManager
    var generatedImageStorage: GeneratedImageStorageMainFunctional
    
    //MARK: - Lifecycle
    
    init(networkManager: MainScreenNetworkManager,
         generatedImageStorage: GeneratedImageStorageMainFunctional) {
        self.networkManager = networkManager
        self.generatedImageStorage = generatedImageStorage
    }
}

//MARK: - MainPageProviderProtocol
extension MainScreenProvider: MainPageProviderProtocol {

    //Проверка на на наличие изображения в базе
    func fetchImageData(queryString: MainPageDataFlow.Request, completion: @escaping (RequestResult<Data>)) {
        let models = generatedImageStorage.getAllItems().filter { $0.queryString == queryString.requestString }
        if let model = models.first {
            completion(.success(model.image))
        } else {
            networkManager.fetchGeneratedImage(queryString: queryString) { result in
                completion(result)
            }
        }
    }
    
    func saveImageToFavorites(model: MainPageDataFlow.AlertFlow.Request, completion: @escaping (Result<Void, Error>) -> Void) {
        generatedImageStorage.save(items: [model.model])
        completion(.success(()))
    }
}
