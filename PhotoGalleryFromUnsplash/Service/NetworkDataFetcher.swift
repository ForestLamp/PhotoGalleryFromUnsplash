//
//  NetworkDataFetcher.swift
//  PhotoGalleryFromUnsplash
//
//  Created by Alex Ch. on 17.05.2022.
//

import Foundation

class NetworkDataFetcher {
    
    private let networkService = NetworkService()
    
    // MARK: - Запрос для поиска
    
    func fetchImages(searchTerm: String, completion: @escaping (SearchResults?) -> ()){
        networkService.searchRequest(searchTerm: searchTerm) { (data, error) in
            if let error = error {
                print("Error reciving request data \(error.localizedDescription)")
                completion(nil)
            }
            let decode = self.decodeJSON(type: SearchResults.self, from: data)
            completion(decode)
        }
    }
   
    // MARK: - Запрос для рандомных фото
    
    func fetchRandomImages(completion: @escaping ([RandomPhotoResult]?)->()){
        networkService.randomRequest { (data, error) in
            if let error = error {
                print("Error reciving request data \(error.localizedDescription)")
                completion(nil)
            }
            let decode = self.decodeJSON(type: [RandomPhotoResult].self, from: data)
            completion(decode)
        }
    }
    
    // MARK: - Декодирование
    
    private func decodeJSON<T: Decodable>(type: T.Type, from: Data?)->T? {
        let decoder = JSONDecoder()
        guard let data = from else {return nil}
        
        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects
        } catch let jsonError{
            print("Failed to decode JSON, \(jsonError)")
            return nil
        }
    }
}
