//
//  NetworkManager.swift
//  devmodecurl
//
//

import Foundation
import Alamofire

let httpMethods:[HTTPMethod] = [
    HTTPMethod.get,
    HTTPMethod.post,
    HTTPMethod.put,
    HTTPMethod.delete,
]

enum AuthenticationType:String, CaseIterable {
    case none = "No Auth"
    case bearerToken = "Bearer token"
    case basicAuth = "Basic Auth"
    case oAuth2 = "OAuth 2"
    
    var requestValue:String {
        switch self {
            case .bearerToken,.oAuth2:
                return "Bearer"
            case .basicAuth:
                return "Basic"
            case .none:
                return ""
        }
    }
}

struct KeyValue:Hashable, Identifiable {
    let id: String
    var key:String
    var value:String
    
    init(key:String, value:String) {
        self.id = UUID().uuidString
        self.key = key
        self.value = value
    }
    
    static func == (lhs: KeyValue, rhs: KeyValue) -> Bool {
        lhs.key == rhs.key && lhs.value == rhs.value
    }
}

struct RequestModel {
    let url:String
    let headers:[KeyValue]
    let parameters:[KeyValue]
    let httpMethod:HTTPMethod
    let authentication:AuthenticationType
    let token:String
    
    var apiParameters:[String:String] {
        return parameters.reduce([String:String].init()) { partialResult, newValue in
            var temp:[String:String] = partialResult
            temp[newValue.key] = newValue.value
            return temp
        }
    }
    
    var apiHeaders:HTTPHeaders {
        var headers = headers.reduce(HTTPHeaders.init()) { partialResult, newValue in
            var temp:HTTPHeaders = partialResult
            temp[newValue.key] = newValue.value
            return temp
        }
        if !self.token.isEmpty {
            headers["Authorization"] = authentication.requestValue + " " + token
        }
        return headers
    }
}

class NetworkManager {
    static let shared = NetworkManager()
    
    var authenticationCode: String?
    var accessToken: String?
    
    func execute(request:RequestModel, completion:@escaping ((String)->Void)) throws {
        guard let url = URL(string: request.url) else {
            throw URLError.init(URLError.Code.badURL)
        }
        AF.request(url, method: request.httpMethod, parameters: request.apiParameters, headers: request.apiHeaders)
            .responseData { response in
                guard let data = response.data, let responseMessage = String.init(data: data, encoding: .utf8) else {
                    debugPrint("Failed to decode data")
                    completion("Failed to decode data")
                    return
                }
                debugPrint(responseMessage)
                completion(responseMessage)
            }
    }
}
    
