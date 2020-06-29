//
//  URLRequestBuilder.swift
//  NetworkingTestingApp
//
//  Created by Петр Тартынских  on 29.06.2020.
//  Copyright © 2020 Петр Тартынских . All rights reserved.
//

import Foundation
import Alamofire

protocol URLRequestBuilder: URLRequestConvertible {
    var baseURL: String { get }
    var path: String { get }
    var headers: HTTPHeaders? { get }
    var parameters: Parameters? { get }
    var method: HTTPMethod { get }
}

extension URLRequestBuilder {
    
    var baseURL: String {
        return "https://api.openweathermap.org"
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        
        switch method {
        case .get:
            request.allHTTPHeaderFields = headers?.dictionary
            request = try URLEncoding.default.encode(request, with: parameters)
        default:
            break
        }
        
        return request
    }
}

enum CharacterProvider {
    
    enum CurrentWeather: URLRequestBuilder {
        case byCityName(name: String)
        case byCoordinates(lat: Int, lon: Int)
        
        var path: String {
            return "data/2.5/weather"
        }
        
        var headers: HTTPHeaders? {
            return nil
        }
        
        var parameters: Parameters? {
            switch self {
            case .byCityName(let name):
                return ["q": name,
                        "appid": PlistParser.apiKey,
                        "units": "metric"]
            case .byCoordinates(let lat, let lon):
                return ["lat": lat,
                        "lon": lon,
                        "appid": PlistParser.apiKey,
                        "units": "metric"]
            }
        }
        
        var method: HTTPMethod {
            return .get
        }
    }
}
