//
//  Networker.swift
//  MVVMCombineExample
//
//  Created by Safwen DEBBICHI on 21/06/2024.
//

import Foundation
import Combine

final class Networker {
    func request<DTO: Decodable>(endpoint: Endpoint) -> AnyPublisher<DTO, MyError>  {
        URLSession.shared.dataTaskPublisher(for: endpoint.url)
            .tryMap { (data: Data, response: URLResponse) in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw MyError.badResponse
                }
                guard (200...220).contains(httpResponse.statusCode) else {
                    throw MyError.serverError(code: httpResponse.statusCode)
                }
                return data
            }
            .decode(type: DTO.self, decoder: JSONDecoder())
            .mapError({ error in
                if error is DecodingError {
                    MyError.decodingError(description: error.localizedDescription)
                } else {
                    MyError.generic(description: error.localizedDescription)
                }
            })
            .eraseToAnyPublisher()
    }
}

enum Endpoint {
    case agify(name: String)
    case genderize(name: String)
    
    var baseURL: String {
        switch self {
        case .agify: "api.agify.io"
        case .genderize: "api.genderize.io"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .agify(let name): [URLQueryItem(name: "name", value: name)]
        case .genderize(let name): [URLQueryItem(name: "name", value: name)]
        }
    }
    
    var url: URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = baseURL
        urlComponents.queryItems = queryItems
        return urlComponents.url!
    }
}

enum MyError: Error {
    case badResponse
    case serverError(code: Int)
    case decodingError(description: String)
    case generic(description: String)
    case dtoMismatch(error: DTOError? = nil)
}

enum DTOError: Error {
    case couldntParseGender
}
