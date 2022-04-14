//
//  NASAapi.swift
//  Nasa_project
//
//  Created by Justin Smith on 2022-04-11.
//

import SwiftUI
import Combine

enum NASAapi {
    
    static let pageSize = 10
    
    static func nasaAPI(page: Int, apiKey: String) -> AnyPublisher<[NASA], Error> {
        let countSize = "&count=\(page)"
        let url = URL(string: "https://api.nasa.gov/planetary/apod?\(apiKey)\(countSize)")!
        
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap { (data, response) in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { throw
                    URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: [NASA].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
