//
//  SettingsModels.swift
//  Swara
//
//  Created by Varshitha VRaj on 30/06/25.
//


import Foundation

struct Section {
    
    let title: String
    let options: [Option]
    
}

struct Option{
    
    let title: String
    let handler: (() -> Void)
    
    
}
