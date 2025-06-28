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
        return false
    }
    
    private var accessToken: String?{
        return nil
    }
    
    private var refreshToken: String? {
        return nil
    }
    
    private var tokenExpirationData: Date?{
        return nil
    }
    
    private var shouldRefreshToken: Bool{
        return false
    }
    
}
