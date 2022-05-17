//
//  NetworkService.swift
//  PhotoGalleryFromUnsplash
//
//  Created by Alex Ch. on 16.05.2022.
//

import Foundation


class NetworkService {
    
    private let numberOfPage = 2
    private let photoPerPage = 90
    private let countRandomResults = 30
    let accessKey = "Client-ID RRSJHKwK0LJ1qXK2IDPdaza2Y8ZtTnXzsHRUcv1BUPU"
    
//MARK: - Запрос для рандомных фото
    
    func randomRequest(completion: @escaping (Data?, Error?) -> Void){
        
        let parameters = self.prepareParametersForRandom()
        let url = self.urlRandomPhoto(params: parameters)
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = prepareHeader()
        request.httpMethod = "get"
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
    
    private func prepareParametersForRandom() -> [String : String] {
        var parameters = [String : String]()
        parameters["count"] = String(countRandomResults)
        return parameters
    }
    
    // TODO: Убрать дублирование кода
    private func urlRandomPhoto(params: [String : String]) -> URL{
        var components = URLComponents()
        components.scheme = Components.scheme.rawValue
        components.host = Components.host.rawValue
        components.path = Components.pathRandom.rawValue
        components.queryItems = params.map{ URLQueryItem(name: $0, value: $1) }
        return components.url!
    }
    
//MARK: - Запрос для поиска
    
    func searchRequest(searchTerm: String, completion: @escaping (Data?, Error?) -> Void){
        
        let parameters = self.prepareParametersForSearch(searchTerm: searchTerm)
        let url = self.url(params: parameters)
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = prepareHeader()
        request.httpMethod = "get"
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
    
    private func prepareHeader()->[String : String]?{
        var headers = [String: String]()
        headers["Authorization"] = accessKey
        return headers
    }
    
    private func prepareParametersForSearch(searchTerm: String?) -> [String : String] {
        var parameters = [String : String]()
        parameters["query"] = searchTerm
        parameters["page"] = String(numberOfPage)
        parameters["per_page"] = String(photoPerPage)
        return parameters
    }
    
    private func url(params: [String : String]) -> URL{
        var components = URLComponents()
        components.scheme = Components.scheme.rawValue
        components.host = Components.host.rawValue
        components.path = Components.path.rawValue
        components.queryItems = params.map{ URLQueryItem(name: $0, value: $1) }
        return components.url!
    }
    
    private func createDataTask(from request: URLRequest, completion: @escaping (Data?, Error?)-> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
    }
}
