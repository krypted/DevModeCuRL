//
//  ContentView.swift
//  devmodecurl
//
//

import SwiftUI

struct RequestView: View {
    @StateObject private var viewModel = RequestViewModel()
    @ViewBuilder var body: some View {
        NavigationView {
            Form {
                TextField("URL", text: self.$viewModel.url)
                Picker("Http Method", selection: $viewModel.httpMethod) {
                    ForEach(httpMethods, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                
                Section  {
                    Picker("Type", selection: $viewModel.authentication) {
                        ForEach(AuthenticationType.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    
                    if self.viewModel.authentication == .oAuth2 {
                        NavigationLink("Fetch Token", destination: OAuth2TokenRequestView{ token in
                            self.viewModel.token = token
                        })
                        if !self.viewModel.token.isEmpty {
                            Text("Token: \(self.viewModel.token)")
                        }
                    }
                    else if self.viewModel.authentication != .none {
                        TextField("Enter " + viewModel.authentication.rawValue, text: $viewModel.token)
                    }
                } header: {
                    Text("Authentication")
                }
                
                Section  {
                    ForEach(self.$viewModel.headers, id: \.self.id) { $header in
                        HStack {
                            TextField("Key", text: $header.key)
                            TextField("Value", text: $header.value)
                        }
                    }.onDelete { index in
                        self.viewModel.headers.remove(atOffsets: index)
                    }
                } header: {
                    HStack {
                        Text("Headers")
                        Spacer()
                        Button {
                            self.viewModel.headers.append(KeyValue(key: "", value: ""))
                        } label: {
                            Image(systemName: "plus")
                                .padding(8)
                                .background(Color.blue)
                                .clipShape(Circle())
                                .foregroundColor(.white)
                        }

                    }

                }
                
                Section  {
                    ForEach(self.$viewModel.parameters, id: \.self.id) { $parameter in
                        HStack {
                            TextField("Key", text: $parameter.key)
                            TextField("Value", text: $parameter.value)
                        }
                    }.onDelete { index in
                        self.viewModel.parameters.remove(atOffsets: index)
                    }
                } header: {
                    HStack {
                        Text("Parameters")
                        Spacer()
                        Button {
                            self.viewModel.parameters.append(KeyValue(key: "", value: ""))
                        } label: {
                            Image(systemName: "plus")
                                .padding(8)
                                .background(Color.blue)
                                .clipShape(Circle())
                                .foregroundColor(.white)
                        }

                    }
                }
                
                NavigationLink(destination: ResponseView(responseModel: self.viewModel.toRequest())) {
                    Text("Submit")
                        .bold()
                }
            }
            .navigationTitle("DevModeCuRL")
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RequestView()
    }
}
