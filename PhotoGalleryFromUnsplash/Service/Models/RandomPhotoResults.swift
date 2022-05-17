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
    let createdAt: String
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

// MARK: - Urls
struct Urls: Decodable {
    let regular, small: String
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
