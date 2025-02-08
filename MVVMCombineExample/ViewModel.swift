//
//  ViewModel.swift
//  MVVMCombineExample
//
//  Created by Safwen DEBBICHI on 21/06/2024.
//

import Foundation
import Observation
import Combine

@Observable
final class ViewModel {
    
    let interactor: Interactor = Interactor()
    var seachHistoryText: String = ""
    var text: String = "" {
        didSet {
            age = -1
            gender = .unknown
            state = nil
        }
    }
    
    init() {
        lastSearch
            .replaceNil(with: "")
            .filter{!$0.isEmpty}
            .scan("Search History:") { $0 + "\n" + $1}
            .assign(to: \.seachHistoryText, on: self)
            .store(in: &cancellables)
    }
    
    var lastSearch: CurrentValueSubject<String?, Never> = .init(nil)
//    var toto: PassthroughSubject<Bool, Never> = .init()
    
    private var cancellables = Set<AnyCancellable>()
    
    var gender: Gender = .unknown
    var age: Int = -1
    private var ageCallError = false
    private var genderCallError = false
    
    func fetchData() {
        lastSearch.send(text)
        // Age
        ageCallError = false
        interactor.getAge(name: text) // AnyPublisher<Int, MyError>
//            .catch { [weak self] error in
//                self?.ageCallError = true
//                return Just(-1)
//            }
            .receive(on: DispatchQueue.main)
            .assign(to: \.age, on: self) // AnyPublisher<Int, Never>
            .store(in: &cancellables)
        // Gender
        genderCallError = false
        interactor.getGender(name: text)
            .catch { [weak self] error in
                self?.genderCallError = true
                return Just(Gender.unknown)
            }
            .receive(on: DispatchQueue.main)
            .assign(to: \.gender, on: self)
            .store(in: &cancellables)
    }
    
    enum State: Equatable {
        case loading, error, success(gender: Gender, age: Int)
    }
    var state: State?
    
    var fetchDataRequestSubscription: AnyCancellable?
    
    func fetchData2() {
        lastSearch.send(text)
        state = .loading
        fetchDataRequestSubscription = interactor.getAge(name: text)
            .zip(interactor.getGender(name: text))
            .map({ (age: Int, gender: Gender) in
                return State.success(gender: gender, age: age)
            })
            .catch { _ in
                return Just(State.error)
            }
            .handleEvents(receiveCancel: { [weak self] in
                print("request cancelled!")
                self?.state = .error
            })
            .receive(on: DispatchQueue.main)
            .assign(to: \.state, on: self)
    }
    
    func cancelFetchData() {
        fetchDataRequestSubscription?.cancel()
    }
}

extension ViewModel {
    func ageDescription(age: Int) -> String {
        guard !ageCallError else { return "Error fetching age" }
        guard !text.isEmpty, age > 0 else { return "" }
        return "\(text) is \(age) years old"
    }
    
    func genderDescription(gender: Gender) -> String {
        guard !genderCallError else { return "Error fetching gender" }
        guard !text.isEmpty, gender.gender != .unknown else { return "" }
        return "\(text)'s gender is \(gender.gender.rawValue) with \(gender.probability * 100)% certainty"
    }
}
