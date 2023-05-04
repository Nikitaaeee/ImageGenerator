//
//  FavoritesDataFlow.swift
//  ImageGenerator
//
//  Created by Nikita Kirshin on 03.05.2023.
//

import Foundation

enum FavoritesDataFlow {
    struct Request {
        let model: GeneratedImageModel
    }
    
    struct Response {
        let cells: [GeneratedImageModel]
    }
    
    struct ViewModel {
        let cells: [GeneratedImageModel]
    }
}
