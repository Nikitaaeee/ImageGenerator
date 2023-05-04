//
//  MainPageNetworkManager.swift
//  ImageGenerator
//
//  Created by Nikita Kirshin on 03.05.2023.
//

import Foundation

struct MainScreenNetworkManager {
    private let networkService = NetworkService<MainPageEndPoint>()
    
    func fetchGeneratedImage(queryString: MainPageDataFlow.Request, completion: @escaping (RequestResult<Data>)) {
        networkService.downloadImage(.fetchGeneratedImage(queryString: queryString.requestString)) { result in
            completion(result)
        }
    }
}
