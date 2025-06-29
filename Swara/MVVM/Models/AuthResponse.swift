//
//  AuthResponse.swift
//  Swara
//
//  Created by Varshitha VRaj on 29/06/25.
//
import Foundation

struct AuthResponse: Codable {
    
    let access_token: String?
    var expires_in : Double = 0.0
    let refresh_token: String?
    let scope: String?
    let token_type: String?
    
    
}
