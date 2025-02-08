//
//  ContentView.swift
//  MVVMCombineExample
//
//  Created by Safwen DEBBICHI on 21/06/2024.
//

import SwiftUI

struct ContentView: View {
    @State var viewModel: ViewModel
    var body: some View {
        ZStack(alignment: .top) {
            Color.indigo.ignoresSafeArea()
            VStack(alignment: .leading) {
                HStack {
                    TextField(text: $viewModel.text) {
                        Text("name")
                    }.textFieldStyle(.roundedBorder)
                    Button(action: {
                        if viewModel.state == .loading {
                            viewModel.cancelFetchData()
                        } else {
//                            viewModel.fetchData()
                            viewModel.fetchData2()
                        }
                    }, label: {
                        Text(viewModel.state == .loading ? "Cancel" : "Search")
                            .foregroundStyle(.white)
                            .padding(8)
                            .background(Color.black)
                            .cornerRadius(8)
                    })
                }
                .padding(.vertical)
                
//                ageAndGenderView(age: viewModel.age, gender: viewModel.gender)
                
                switch viewModel.state {
                case .loading:
                    ProgressView()
                case .error:
                    Text("Ouups! Error")
                        .foregroundStyle(.white)
                case .success(let gender, let age):
                    ageAndGenderView(age: age, gender: gender)
                case .none:
                    EmptyView()
                }
                
                Text(viewModel.seachHistoryText)
                    .foregroundStyle(.white)
                    .padding(.vertical)
            }
            .padding()
        }
    }
    
    func ageAndGenderView(age: Int, gender: Gender) -> some View{
        VStack(alignment: .leading) {
            Text(viewModel.ageDescription(age: age))
                .foregroundStyle(.white)
                .padding(.vertical)
            Text(viewModel.genderDescription(gender: gender))
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    ContentView(viewModel: .init())
}
