//
//  URLParametersEncoder.swift
//  ImageGenerator
//
//  Created by Nikita Kirshin on 03.05.2023.
//

import Foundation

struct URLParameterEncoder: ParameterEncoder {
    static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        guard let url = urlRequest.url else { throw NetworkError.missingUrl }
        if var urlComponents = URLComponents(
            url: url,
            resolvingAgainstBaseURL: false
        ), !parameters.isEmpty {
            urlComponents.queryItems = [URLQueryItem]()

            for (key, value) in parameters {
                let queryItems = URLQueryItem(
                    name: key,
                    value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                )
                urlComponents.queryItems?.append(queryItems)
            }
            urlRequest.url = urlComponents.url
        }
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/x-www-urlencoded; characters=utf-8", forHTTPHeaderField: "Content-Type")
        }
    }
}
