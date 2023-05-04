//
//  MainPageDataFlow.swift
//  ImageGenerator
//
//  Created by Nikita Kirshin on 02.05.2023.
//

import Foundation

enum MainPageDataFlow {
    struct Request {
        var requestString: String
    }
    
    struct Response {
        var imageData: Data
    }
    
    struct ViewModel {
        var generateImageButtonModel: DefaultButtonModel
        var addToFavoritesButtonModel: DefaultButtonModel
    }
    
    enum PresentGeneratedImageFlow {
        struct Response {
            let imageData: Data
        }
        
        struct ViewModel {
            let imageData: Data
        }
    }
    
    enum AlertFlow {
        struct Request {
            let model: GeneratedImageModel
        }
        
        struct ViewModel {
            let alertTitle: String
            let alertMessage: String
        }
    }
}
