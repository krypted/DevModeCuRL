//
//  RequestViewModel.swift
//  Devmodecurl
//
//

import Foundation
import Alamofire


class RequestViewModel: ObservableObject {
    @Published var url:String = "https://iana.org"
    @Published var headers:[KeyValue] = []
    @Published var parameters:[KeyValue] = []
    @Published var httpMethod:HTTPMethod = .get
    @Published var authentication:AuthenticationType = .oAuth2
    @Published var token:String = "" 
    
    func toRequest() -> RequestModel {
        return RequestModel(
            url: url,
            headers: headers,
            parameters: parameters,
            httpMethod: httpMethod,
            authentication: authentication,
            token: token
        )
    }
}
