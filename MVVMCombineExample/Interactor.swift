//
//  Interactor.swift
//  MVVMCombineExample
//
//  Created by Safwen DEBBICHI on 21/06/2024.
//

import Foundation
import Combine

protocol InteractorProtocol {
    func getAge(name: String) -> AnyPublisher<Int, MyError>
    func getGender(name: String) -> AnyPublisher<Gender, MyError>
}

final class Interactor: InteractorProtocol {
    
    let repository: Repository = .init()
    
    func getAge(name: String) -> AnyPublisher<Int, MyError> {
        repository.getAge(name: name).map { $0.age }.eraseToAnyPublisher()
    }
    
    func getGender(name: String) -> AnyPublisher<Gender, MyError> {
        repository.getGender(name: name)
    }
}
