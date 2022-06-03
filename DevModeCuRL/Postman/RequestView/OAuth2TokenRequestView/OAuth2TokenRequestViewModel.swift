//
//  OAuth2TokenRequestViewModel.swift
//  Devmodecurl
//
//

import Foundation
import UIKit
import Alamofire

class OAuth2TokenRequestViewModel: ObservableObject {
    @Published var authUrl:String = "https://accounts.google.com/o/oauth2/auth"
    @Published var accessTokenUrl:String = "https://accounts.google.com/o/oauth2/token"
    @Published var clientId:String = "MyUserString"
    @Published var clientSecret:String = ""
    @Published var scope:String = "https://www.googleapis.com/auth/gmail.readonly"
    @Published var state:String = "TEST_STATE"
    @Published var responseType:String = "code"
    @Published var grantType:String = "authorization_code"
    @Published var curl:String = ""
    
    private let callbackUrl:String = "com.krypted.devmodecurl://"
    private var task:URLSessionDataTask?
    
    var authenticationCode:String = ""
    
    func getAccessToken() {
        if let authURL:URL = getAuthCodeURL() {
          UIApplication.shared.open(authURL)
        }
      }
    
    func generateCurl() {
        if let authURL:URL = getAuthCodeURL() {
            self.curl = URLRequest.init(url: authURL).cURL()
        }
    }
    
    func getAuthCodeURL() -> URL? {
        let parameters = [
            KeyValue(key: "client_id", value: clientId),
            KeyValue(key: "redirect_uri", value: self.callbackUrl),
            KeyValue(key: "client_secret", value: clientSecret),
            KeyValue(key: "scope", value: scope),
            KeyValue(key: "state", value: state),
            KeyValue(key: "response_type", value: responseType),
            
        ]
        let requestModel = RequestModel(
            url: authUrl,
            headers: [],
            parameters: parameters,
            httpMethod: .get,
            authentication: .oAuth2,
            token: ""
        )
        
        if let authURL:URL = URLHelper.toURLRequest(from: requestModel)?.url?.absoluteURL {
          return authURL
        }
        return nil
    }
    
    func exchangeCodeWithTokenURL(completion:@escaping ((String) -> Void)) {
        
        let parameters = [
            KeyValue(key: "client_id", value: clientId),
            KeyValue(key: "client_secret", value: clientSecret),
            KeyValue(key: "grant_type", value: grantType),
            KeyValue(key: "redirect_uri", value: self.callbackUrl),
            KeyValue(key: "code", value: authenticationCode),
        ]
        
        let requestModel = RequestModel(
            url: accessTokenUrl,
            headers: [],
            parameters: parameters,
            httpMethod: .post,
            authentication: .none,
            token: ""
        )
        
        guard let request = URLHelper.toURLRequest(from: requestModel) else {
            return
        }
        
        print(request.cURL())
        
        try? NetworkManager.shared.execute(request: requestModel) { responseValue in
            debugPrint(responseValue)
            if let data = responseValue.data(using: .utf8) {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                    if let token = json?["access_token"] as? String {
                        completion(token)
                    }
                    debugPrint(json)
                } catch {
                    print("Something went wrong")
                }
            }
        }
    }
    
    func setGmailUrls() {
        self.authUrl = "https://accounts.google.com/o/oauth2/auth"
        self.accessTokenUrl = "https://accounts.google.com/o/oauth2/token"
        self.clientId = "MyUserString"
        self.clientSecret = ""
        self.scope = "https://www.googleapis.com/auth/gmail.readonly"
        self.state = "TEST_STATE"
    }
}
