//
//  NetworkError.swift
//  ImageGenerator
//
//  Created by Nikita Kirshin on 03.05.2023.
//

import Foundation

enum NetworkError: String, CustomNSError {
    case successfulConnection = "Successful connection"
    case connectionFailed = "No internet connection"
    case redirection = "Redirection"
    case encodingFailed = "Parameters encoding failed"
    case missingUrl = "URL is nil"
    case serverError = "Server errors"
    case clientError = "Client error with connection"
    
    var errorUserInfo: [String : Any] {
        [NSLocalizedDescriptionKey: self.rawValue]
    }
}
