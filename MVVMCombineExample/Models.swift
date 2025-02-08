//
//  Model.swift
//  MVVMCombineExample
//
//  Created by Safwen DEBBICHI on 21/06/2024.
//

import Foundation

enum GenderType: String {
    case male, female, unknown
}

struct Age {
    var name: String
    var age: Int
}

struct Gender: Equatable {
    var name: String
    var gender: GenderType
    var probability: Double
    
    static let unknown = Gender(name: "", gender: .unknown, probability: 1.0)
}

