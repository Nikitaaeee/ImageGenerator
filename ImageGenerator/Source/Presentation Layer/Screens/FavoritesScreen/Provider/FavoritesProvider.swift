//
//  FavoritesProvider.swift
//  ImageGenerator
//
//  Created by Nikita Kirshin on 03.05.2023.
//

import Foundation

protocol FavoritesProviderProtocol {
    func fetchImageData(completion: @escaping (Result<[GeneratedImageModel], Error>) -> Void)
    func deleteGeneratedImage(with request: FavoritesDataFlow.Request)
}

final class FavoritesProvider {
    
    //MARK: - Properties
    var generatedImageStorage: GeneratedImageStorageMainFunctional
    
    //MARK: - Lifecycle
    
    init(generatedImageStorage: GeneratedImageStorageMainFunctional) {
        self.generatedImageStorage = generatedImageStorage
    }
}

//MARK: - FavoritesProviderProtocol

extension FavoritesProvider: FavoritesProviderProtocol {
    func fetchImageData(completion: @escaping (Result<[GeneratedImageModel], Error>) -> Void) {
        let model = generatedImageStorage.getAllItems()
        completion(.success((model)))
    }
    
    func deleteGeneratedImage(with request: FavoritesDataFlow.Request) {
        generatedImageStorage.deleteItem(request.model)
    }
}
