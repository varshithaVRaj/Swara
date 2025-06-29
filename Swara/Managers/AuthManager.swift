//
//  AuthManager.swift
//  Swara
//
//  Created by Varshitha VRaj on 23/06/25.
//

import Foundation

final class AuthManager {
    
//relvent Subclassing: If you want to prevent subclassing to maintain control over the behavior and state of the class.

//Optimization: The Swift compiler can optimize code involving final classes more effectively, since it knows there won't be any inheritance.

//Cleaner Code: It indicates your intent more clearly, suggesting that the class is meant to stand alone without being extended or modified.
    
    static let shared = AuthManager()
    
    struct Constants{
        
        static let clientID = "06615e61d1644b65894985ee34535fb8"
        static let clientSecrate = "2f42a651d23d4671bb4974b05a55b21c"
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
    }
    
    private init() {}
    
     var signInURL: URL? {
        
        let scopes = "user-read-private"
        let redirectURI = "https://www.google.com/"
        let baseURL = "https://accounts.spotify.com/authorize"
        let string =  "\(baseURL)?response_type=code&client_id=\(Constants.clientID)&scope=\(scopes)&redirect_uri=\(redirectURI)&show_dialog=TRUE"
        return URL(string: string)
    }
    
    var isSignedIn: Bool {
        return accessToken != nil
    }
    
    private var accessToken: String?{
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
      
    }
    
    private var tokenExpirationData: Date?{
        return UserDefaults.standard.object(forKey: "expires_in") as? Date
      
    }
    
    private var shouldRefreshToken: Bool{
        
        guard let expirationDate = tokenExpirationData else {
            return false
        }
       
        let currentDate = Date()
        let fiveMinutes: TimeInterval = 30
        return currentDate.addingTimeInterval(fiveMinutes) >= expirationDate
      
    }
    
    public func exchangeCodeForToken(code: String, completion: @escaping (Bool) -> Void){
        
        guard let url = URL(string: Constants.tokenAPIURL) else {
            return
        }
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: "https://www.google.com/")
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        
       
        let basicToken = "\(Constants.clientID)" + ":" + "\(Constants.clientSecrate)"
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("Failure to get base 64")
            completion(false)
            return
        }
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")

        
        let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard let data = data, error == nil else{
                completion(false)
                return
            }
            
            do{
        
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self.cacheToken(result: result)
                completion(true)
                
//                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//                print("success: \(json)")
//                completion(true)
                
            }catch{
                print(error.localizedDescription)
                completion(false)
            }
        }
        task.resume()
    }
    
    public func refreshAccessToken(){
        
        
    }
    
    private func cacheToken(result: AuthResponse){
        
        UserDefaults.standard.set(result.access_token, forKey: "access_token")
        UserDefaults.standard.set(result.expires_in, forKey: "expires_in")
        UserDefaults.standard.set(result.refresh_token, forKey: "refresh_token")
        UserDefaults.standard.set(result.scope, forKey: "scope")
        UserDefaults.standard.set(result.token_type, forKey: "token_type")
        
        UserDefaults.standard.setValue(Date().addingTimeInterval(result.expires_in), forKey: "expirationDate")
        
 
        
    }
    
}
