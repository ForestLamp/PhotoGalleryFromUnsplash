//
//  SearchResults.swift
//  PhotoGalleryFromUnsplash
//
//  Created by Alex Ch. on 17.05.2022.
//

import Foundation

struct SearchResults: Decodable {
    let total: Int
    let results: [UnsplashPhoto]
    
}

struct UnsplashPhoto: Decodable {
    let width: Int
    let height: Int
    let created_at: String
    let user: UserName
    let urls: [URLKind.RawValue:String]
    
    enum URLKind: String {
        case raw
        case full
        case regular
        case small
        case thumb
        
    }
}

struct UserName: Decodable {
    let name: String?
}
