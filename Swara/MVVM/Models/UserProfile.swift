//
//  UserProfile.swift
//  Swara
//
//  Created by Varshitha VRaj on 23/06/25.
//

struct UserProfile: Codable {
    
    var country: String?
    var display_name: String?
    var explicit_content: ExplicitContent?
    var external_urls: ExternalUrls?
    var followers: Followers?
    var href: String?
    var id: Int?
    var images: String?
    var product: String?
    var type: String?
    var uri: String?
   

    
}

struct ExplicitContent: Codable{
    
    
    var filter_enabled: Int?
    var filter_locked: Int?
    
}


struct ExternalUrls: Codable {
    
    var spotify: String?
  
    
}


struct Followers: Codable{
    
    var href: String?
    var total: Int?

}





