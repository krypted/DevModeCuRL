//
//  OAuth2TokenRequestView.swift
//  Devmodecurl
//
//

import SwiftUI

struct OAuth2TokenRequestView: View {
    @StateObject private var viewModel = OAuth2TokenRequestViewModel()
    @Environment(\.presentationMode) var presentation
    let completion:((String) -> Void)
    
    var body: some View {
        Form {
            TextField("Auth URL", text: $viewModel.authUrl)
            TextField("Access Token URL", text: $viewModel.accessTokenUrl)
            TextField("Client ID", text: $viewModel.clientId)
            TextField("Client Secret", text: $viewModel.clientSecret)
            TextField("Scope", text: $viewModel.scope)
            TextField("State", text: $viewModel.state)
            
            Button {
                self.viewModel.generateCurl()
            } label: {
                Text("Generate Curl")
                    .bold()
            }
            
            if !self.viewModel.curl.isEmpty {
                
                Text(self.viewModel.curl)
                
                Button  {
                    self.viewModel.getAccessToken()
                } label: {
                    Text("Get New Access Token")
                        .bold()
                        .tint(.green)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Button {
                        self.viewModel.setGmailUrls()
                    } label: {
                        Text("Reset to Gmail")
                    }
                }
            }
        }
        .navigationTitle("OAuth2 Access Token")
        .onOpenURL { url in
            debugPrint(url.absoluteString)
            
            let components = NSURLComponents(url: url, resolvingAgainstBaseURL: false)
            if let queryItems = components?.queryItems {
                for queryItem in queryItems
                {
                    if queryItem.name == "code" {
                        self.viewModel.authenticationCode = queryItem.value ?? ""
                        self.viewModel.exchangeCodeWithTokenURL { token in
                            completion(token)
                            self.presentation.wrappedValue.dismiss()
                        }
                    }
                }
            }
        }
    }
}

struct OAuth2TokenRequestView_Previews: PreviewProvider {
    static var previews: some View {
        OAuth2TokenRequestView { token in
            
        }
    }
}
