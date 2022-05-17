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
    let createdAt: Date
    let width, height: Int
    let location: Location
    let urls: Urls
    let user: User

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width, height, location, urls, user
    }
}

// MARK: - Location
struct Location: Decodable {
    let name: String
    let position: Position
}

// MARK: - Position
struct Position: Decodable {
    let latitude, longitude: Double
}

// MARK: - Urls
struct Urls: Decodable {
    let regular, small: String
}

// MARK: - User
struct User: Decodable {
    let id: String
    let updatedAt: Date
    let name, location: String
    let totalLikes, totalPhotos, totalCollections: Int

    enum CodingKeys: String, CodingKey {
        case id
        case updatedAt = "updated_at"
        case name, location
        case totalLikes = "total_likes"
        case totalPhotos = "total_photos"
        case totalCollections = "total_collections"
    }
}
