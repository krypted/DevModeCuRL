//
//  ResponseView.swift
//  Devmodecurl
//
//

import SwiftUI

struct ResponseView: View {
    @StateObject private var viewModel:ResponseViewModel
    
    init(responseModel:RequestModel) {
        _viewModel = StateObject(wrappedValue: ResponseViewModel(responseModel: responseModel))
    }
    
    var body: some View {
        VStack(alignment:.leading) {
            // Curl Request
            Text(viewModel.toCurl())
            
            // Action
            Button {
                self.viewModel.hitTheServer()
            } label: {
                Text("Send Request") 
            }.frame(maxWidth:.infinity)
                .buttonStyle(.borderedProminent)
            
            Divider()

            // Response
            ScrollView {
                Text(self.viewModel.serverResponse)
            }
        }
        .multilineTextAlignment(.leading)
        .padding()
        .navigationBarTitleDisplayMode(.inline)
    }
}

