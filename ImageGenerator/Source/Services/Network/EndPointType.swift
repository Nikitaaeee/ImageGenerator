//
//  EndPointType.swift
//  ImageGenerator
//
//  Created by Nikita Kirshin on 03.05.2023.
//

import Foundation

protocol EndPointType {
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}

enum EndPointAPI {
    static let scheme = "https"
    static let hostURL = "dummyimage.com"
}
