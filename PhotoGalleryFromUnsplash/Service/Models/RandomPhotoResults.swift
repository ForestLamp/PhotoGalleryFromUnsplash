//
//  SearchResults.swift
//  PhotoGalleryFromUnsplash
//
//  Created by Alex Ch. on 17.05.2022.
//

import Foundation

// MARK: - RandomPhotoResult
struct RandomPhotoResult: Decodable {
    let id: String
    let created_at: String
    let width, height: Int
    let downloads: Int
    let location: Location
    let urls: [URLKind.RawValue:String]
    let user: User
    
    enum URLKind: String {
        case raw
        case full
        case regular
        case small
        case thumb
    }
}

// MARK: - Location
struct Location: Decodable {
    let name: String?
    let position: Position
}

// MARK: - Position
struct Position: Decodable {
    let latitude, longitude: Double?
}

// MARK: - User
struct User: Decodable {
    let id: String?
    let name, location: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name, location
    }
}
