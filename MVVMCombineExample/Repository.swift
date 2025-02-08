//
//  Repository.swift
//  MVVMCombineExample
//
//  Created by Safwen DEBBICHI on 21/06/2024.
//

import Foundation
import Combine

protocol RepositoryProtocol {
    func getAge(name: String) -> AnyPublisher<Age, MyError>
    func getGender(name: String) -> AnyPublisher<Gender, MyError>
}

final class Repository: RepositoryProtocol {
    
    let networker = Networker()
    
    func getAge(name: String) -> AnyPublisher<Age, MyError> {
        let agifyPublisher: AnyPublisher<AgeDTO, MyError> = networker.request(endpoint: .agify(name: name))
        return agifyPublisher
            .map{ $0.toDomain() }
            .eraseToAnyPublisher()
    }
    
    func getGender(name: String) -> AnyPublisher<Gender, MyError> {
        let genderizePublisher: AnyPublisher<GenderDTO, MyError> = networker.request(endpoint: .genderize(name: name))
        return genderizePublisher
            .tryMap { try $0.toDomain() }
            .mapError({ error in
                MyError.dtoMismatch(error: error as? DTOError)
            })
            .eraseToAnyPublisher()
    }
}
