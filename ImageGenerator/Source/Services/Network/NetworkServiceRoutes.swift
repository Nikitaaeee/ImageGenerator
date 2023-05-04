//
//  NetworkServiceRoutes.swift
//  ImageGenerator
//
//  Created by Nikita Kirshin on 03.05.2023.
//

import Foundation

typealias RequestResult<Type> = ((Result<Type?, NetworkError>) -> Void)

protocol NetworkServiceRoutes: AnyObject {
    associatedtype EndPoint: EndPointType

    func downloadImage(_ route: EndPoint, completion: @escaping RequestResult<Data>)
}
