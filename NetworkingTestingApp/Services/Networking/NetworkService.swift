//
//  NetworkService.swift
//  NetworkingTestingApp
//
//  Created by Петр Тартынских  on 29.06.2020.
//  Copyright © 2020 Петр Тартынских . All rights reserved.
//

import Foundation
import Alamofire

enum NetworkServiceError: Error {
    case notFound
    case serverError
    case unknownError(_ error: Error)
}

protocol NetworkService {
    func load<Service: URLRequestBuilder, Model: Codable>(service: Service, decodeType: Model.Type, completion: @escaping (Result<Model, NetworkServiceError>) -> Void)
}

final class NetworkServiceImplementation: NetworkService {
    
    static let shared = NetworkServiceImplementation()
    
    private init() {}
    
    func load<Service: URLRequestBuilder, Model: Codable>(service: Service, decodeType: Model.Type, completion: @escaping (Result<Model, NetworkServiceError>) -> Void) {
        guard let urlRequest = service.urlRequest else { return }
        
        AF.request(urlRequest).validate().responseDecodable(of: Model.self) { (response) in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                guard let code = error.responseCode else {
                    completion(.failure(.unknownError(error)))
                    return
                }
                switch code {
                case 404:
                    completion(.failure(.notFound))
                case 500...599:
                    completion(.failure(.serverError))
                default:
                    completion(.failure(.unknownError(error)))
                }
            }
        }
    }
}
