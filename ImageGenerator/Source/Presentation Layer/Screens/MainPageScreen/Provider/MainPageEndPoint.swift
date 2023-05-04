//
//  MainPageEndPoint.swift
//  ImageGenerator
//
//  Created by Nikita Kirshin on 03.05.2023.
//

import Foundation

enum MainPageEndPoint {
    case fetchGeneratedImage(queryString: String)
}

extension MainPageEndPoint: EndPointType {
    var path: String {
        switch self {
        case .fetchGeneratedImage(queryString: let queryString):
            return "/500x500&text=\(queryString)"
        }
    }
    
    var httpMethod: HTTPMethod {
        .get
    }
    
    var task: HTTPTask {
        switch self {
        case .fetchGeneratedImage(queryString: _):
            return .request
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
