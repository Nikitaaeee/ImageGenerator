//
//  NetworkService.swift
//  ImageGenerator
//
//  Created by Nikita Kirshin on 03.05.2023.
//

import Foundation

final class NetworkService<EndPoint: EndPointType>: NetworkServiceRoutes {
    private var task: URLSessionTask?
    
    func downloadImage(_ route: EndPoint, completion: @escaping RequestResult<Data>) {
        let session = URLSession.shared
        
        do {
            guard let request = try self.buildRequest(from: route) else { return }
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                
                DispatchQueue.main.async {
                    guard let data = data, error == nil else {
                        completion(.failure(NetworkError.connectionFailed))
                        return
                    }
                    
                    guard let response = response as? HTTPURLResponse else { return }
                    print(response.statusCode)
                    switch response.statusCode {
                    case 200..<299:
                        completion(.success(data))
                    case 300..<399:
                        completion(.failure(NetworkError.redirection))
                    case 400..<499:
                        completion(.failure(NetworkError.clientError))
                    case 500..<599:
                        completion(.failure(NetworkError.serverError))
                    default:
                        completion(.failure(NetworkError.connectionFailed))
                    }
                }
            })
        } catch {
            DispatchQueue.main.async {
                completion(.failure(NetworkError.connectionFailed))
            }
        }
        self.task?.resume()
    }
    
    func cancel() {
        self.task?.cancel()
    }
}

private extension NetworkService {
    func buildRequest(from route: EndPoint) throws -> URLRequest? {
        guard let url = configureURL(route: route) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = route.httpMethod.rawValue
        switch route.task {
        case .request:
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        return request
        
    }
    
    func configureURL(route: EndPoint) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = EndPointAPI.scheme
        urlComponents.host = EndPointAPI.hostURL
        urlComponents.path = route.path
        return urlComponents.url
    }
    
    func configureParameters(bodyParameters: Parameters?, urlParameters: Parameters?, request: inout URLRequest) throws {
        
        do {
            if let bodyParameters = bodyParameters {
                try JSONParameterEncoder.encode(urlRequest: &request, with: bodyParameters)
            }
            if let urlParameters = urlParameters {
                try URLParameterEncoder.encode(urlRequest: &request, with: urlParameters)
            }
        } catch {
            throw error
        }
    }
    
    func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
    func jsonDecode<T: Decodable>(type: T.Type, from data: Data?) -> T? {
        let decoder = JSONDecoder()
        guard
            let data = data,
            let response = try? decoder.decode(type.self, from: data) else { return nil }
        
        return response
    }
}
