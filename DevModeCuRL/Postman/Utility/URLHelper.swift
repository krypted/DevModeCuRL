//
//  URLHelper.swift
//  DevModeCurl
//
//

import Foundation

class URLHelper {
    static func toURLRequest(from requestModel:RequestModel) -> URLRequest? {
        guard let requestUrl = URL.init(string: requestModel.url) else {
            return nil
        }
        
        var request = URLRequest(url: requestUrl)
        
        // Body
        switch requestModel.httpMethod {
            case .get:
                guard var urlComponent = URLComponents(string: requestUrl.absoluteString), !requestModel.parameters.isEmpty else {
                    break
                }
                urlComponent.queryItems = requestModel.parameters
                    .map { URLQueryItem(name: $0.key, value: $0.value) }
                
                request = URLRequest.init(url: urlComponent.url!)
                break
            case .post,.patch,.delete:
                let parameters = requestModel.parameters
                    .map { "\($0.key)=\($0.value)" }
                    .joined(separator: "&")
                request.httpBody = parameters.data(using: String.Encoding.utf8)
                break
            default:
                break
        }
        
        // Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if requestModel.authentication != .none {
            request.setValue((requestModel.authentication.requestValue + " " + requestModel.token), forHTTPHeaderField: "Authorization")
        }
        
        // Method
        request.httpMethod = requestModel.httpMethod.rawValue
        
        return request
    }
}
