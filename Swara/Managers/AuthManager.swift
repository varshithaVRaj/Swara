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
    private var refreshingToken = false
    
    struct Constants{
        
        static let clientID = "06615e61d1644b65894985ee34535fb8"
        static let clientSecrate = "2f42a651d23d4671bb4974b05a55b21c"
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
        static let scopes = "user-read-private%20playlist-modify-private%20playlist-read-collaborative%20playlist-read-private%20user-follow-read%20user-library-modify%20user-library-read"
        static let redirectURI = "https://www.google.com/"
    }
    
    private init() {}
    
     var signInURL: URL? {

        let baseURL = "https://accounts.spotify.com/authorize"
         let string =  "\(baseURL)?response_type=code&client_id=\(Constants.clientID)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redirectURI)&show_dialog=TRUE"
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
        
        refreshingToken = true
        let currentDate = Date()
        let fiveMinutes: TimeInterval = 300
        return currentDate.addingTimeInterval(fiveMinutes) >= expirationDate
      
    }
    
    public func exchangeCodeForToken(code: String, completion: @escaping (Bool) -> Void){
        
        //MARK: Create URL
        
        guard let url = URL(string: Constants.tokenAPIURL) else {
            return
        }
        
        //MARK: Create Components
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: "https://www.google.com/")
        ]
        
        //MARK: Create URL Request
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
                self.onRefreshBlock.forEach{$0(result.access_token ?? "") }
                self.onRefreshBlock.removeAll()
                self.cacheToken(result: result)
                completion(true)
                
            }catch{
                print(error.localizedDescription)
                completion(false)
            }
        }
        task.resume()
    }
    
    
    private var onRefreshBlock = [(String) -> Void]()
    
    
    
    
    // supplies valid token with API Calls
    public func withValidToken(completion: @escaping(String)-> Void){
        
        guard !refreshingToken else {
            // Append the completion
            onRefreshBlock.append(completion)
            return
        }
        
        
        if shouldRefreshToken {
            // Refresh
            refreshIfNeeded{[weak self] success in
                
                if success {
                    if let token = self?.accessToken, success {
                        completion(token)
                    }
                }
            }
        }else if let token = self.accessToken {
            completion(token)
        }
    
    }
 
    
    public func refreshIfNeeded(completion: @escaping (Bool) -> Void){
        
        guard !refreshingToken else {
            return
        }
        
        guard shouldRefreshToken else {
           completion(true)
            return
        }
        
        guard self.refreshToken != nil else {
            return
        }
        
        
        //MARK: Create URL
        
        guard let url = URL(string: Constants.tokenAPIURL) else {
            return
        }
        
        refreshingToken = true
        
        //MARK: Create Components
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "redirect_uri", value: "https://www.google.com/")
        ]
        
        //MARK: Create URL Request
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
            self.refreshingToken = false
            guard let data = data, error == nil else{
                completion(false)
                return
            }
            
            do{
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                print("successfully refreshed token")
                self.cacheToken(result: result)
                completion(true)
                
            }catch{
                print(error.localizedDescription)
                completion(false)
            }
        }
        task.resume()

    }
    
    private func cacheToken(result: AuthResponse){
        
        UserDefaults.standard.set(result.access_token, forKey: "access_token")
        UserDefaults.standard.set(result.expires_in, forKey: "expires_in")
        
        if let refresh_token = result.refresh_token{
            UserDefaults.standard.set(refresh_token, forKey: "refresh_token")
        }
        
        
        UserDefaults.standard.set(result.scope, forKey: "scope")
        UserDefaults.standard.set(result.token_type, forKey: "token_type")
        UserDefaults.standard.setValue(Date().addingTimeInterval(result.expires_in), forKey: "expirationDate")
        print("Access token expires in \( UserDefaults.standard.setValue(Date().addingTimeInterval(result.expires_in), forKey: "expirationDate"))")
        

    }
    
}
