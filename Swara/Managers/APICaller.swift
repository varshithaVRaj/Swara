//
//  APICaller.swift
//  Swara
//
//  Created by Varshitha VRaj on 23/06/25.
//

import Foundation

final class APICaller{
    
    static let shared = APICaller()
    
    private init(){}
    
    
    struct Constants{
        
        static let baseURL = "https://api.spotify.com/v1"
        
        
        
    }
    
    
    public func getCurrentUsrtProfile(completion: @escaping(Result<UserProfile, Error>) -> Void){
        
        createRequest(with: URL(string: Constants.baseURL + "/me"),
                      type: .GET) { baseRequest in
            
            print("the request created is \(baseRequest)")
            
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                
                guard let data = data, error == nil else {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: nil)))
                    return
                }
                
                print("the data is \(data)")
                
                
                do{
//                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
                    let result = try JSONSerialization.jsonObject(with: data)
                    print("the result of profile url is \(result)")
                    //completion(.success(result))
                    
                }catch{
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    
    enum HTTPMethod: String {
        case GET
        case POST
    }
    
    
    
    private func createRequest(with url: URL?,type: HTTPMethod, completion: @escaping(URLRequest) -> Void){
        
        
        AuthManager.shared.withValidToken { token in
            guard let apiURL = url else {
                return
            }
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            completion(request)
        }
        
        
        
    }
    
    
}
