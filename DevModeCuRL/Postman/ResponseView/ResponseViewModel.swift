//
//  ResponseViewModel.swift
//  devmodecurl
//
//

import Foundation

class ResponseViewModel: ObservableObject {
    
    @Published private(set) var serverResponse:String = ""
    private let requestModel:RequestModel
    private var task:URLSessionDataTask?
    
    init(responseModel:RequestModel) {
        self.requestModel = responseModel
    }
    
    func hitTheServer() {
        try? NetworkManager.shared.execute(request: requestModel) { responseValue in
            OperationQueue.main.addOperation {
                self.serverResponse = responseValue
            }
        }
    }
    
    func toURLRequest() -> URLRequest? {
        return URLHelper.toURLRequest(from: requestModel)
    }
    
    func toCurl() -> String {
        guard let request = self.toURLRequest() else {
            return "Bad URL"
        }
        return request.cURL()
    }
}

extension URLRequest {
    func cURL(pretty: Bool = false) -> String {
        let newLine = pretty ? "\\\n" : ""
        let method = (pretty ? "--request " : "-X ") + "\(self.httpMethod ?? "GET") \(newLine)"
        let url: String = (pretty ? "--url " : "") + "\'\(self.url?.absoluteString ?? "")\' \(newLine)"
        
        var cURL = "curl "
        var header = ""
        var data: String = ""
        
        if let httpHeaders = self.allHTTPHeaderFields, httpHeaders.keys.count > 0 {
            for (key,value) in httpHeaders {
                header += (pretty ? "--header " : "-H ") + "\'\(key): \(value)\' \(newLine)"
            }
        }
        
        if let bodyData = self.httpBody, let bodyString = String(data: bodyData, encoding: .utf8),  !bodyString.isEmpty {
            data = "--data '\(bodyString)'"
        }
        
        cURL += method + url + header + data
        
        return cURL
    }
}
