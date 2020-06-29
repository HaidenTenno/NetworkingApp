//
//  NetworkService.swift
//  NetworkingTestingApp
//
//  Created by Петр Тартынских  on 29.06.2020.
//  Copyright © 2020 Петр Тартынских . All rights reserved.
//

import Foundation
import Alamofire

protocol NetworkService {
    func load<Service: URLRequestBuilder, Model: Codable>(service: Service, decodeType: Model.Type, completion: @escaping (Alamofire.AFResult<Model>) -> Void)
}

final class NetworkServiceImplementation: NetworkService {
    
    static let shared = NetworkServiceImplementation()
    
    private init() {}
    
    func load<Service: URLRequestBuilder, Model: Codable>(service: Service, decodeType: Model.Type, completion: @escaping (AFResult<Model>) -> Void) {
        guard let urlRequest = service.urlRequest else { return }
        
        AF.request(urlRequest).responseDecodable(of: Model.self) { (response) in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
