//
//  DTOs.swift
//  MVVMCombineExample
//
//  Created by Safwen DEBBICHI on 21/06/2024.
//

import Foundation

struct AgeDTO: Decodable {
    var name: String
    var age: Int
    
    func toDomain() -> Age {
        .init(name: name, age: age)
    }
}

struct GenderDTO: Decodable {
    var name: String
    var gender: String
    var probability: Double
    
    func toDomain() throws -> Gender {
        guard let gender = GenderType(rawValue: gender) else {
            throw DTOError.couldntParseGender
        }
        return .init(name: name, gender: gender, probability: probability)
    }
}
