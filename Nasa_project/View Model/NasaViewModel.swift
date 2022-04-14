//
//  NasaViewModel.swift
//  Nasa_project
//
//  Created by Justin Smith on 2022-04-09.
//

import SwiftUI
import Combine

class NASAViewModel: ObservableObject {
    
    @Published var nasaItems = [NASAItem]()
    @Published private(set) var state = State()
    @Published var nextPage = false
    private var subscriptions = Set<AnyCancellable>()
    private var apiKey = "api_key=41OqR4nzBaWLOVDzr4P6EylhQSG2RYaYEKziSFlG"
    let manager = LocalFileManager.instance
    private var counter = 0
    
    func getMoreNASAPictures() {
        guard state.canLoadNextPage else { return }
        
        NASAapi.nasaAPI(page: state.page, apiKey: apiKey)
            .sink(receiveCompletion: { _ in }) { nasaWebData in
                for i in 0..<self.state.page {
                    let nasaItem = NASAItem(id: self.counter, nasaItem: nasaWebData[i], favourite: false)
                    self.nasaItems.append(nasaItem)
                    self.counter = self.counter + 1
                }
            }
            .store(in: &subscriptions)
    }
    
    private func onReceive(_ completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure:
            state.canLoadNextPage = false
        }
    }
    
    private func onReceive(_ nasaItemData: [NASAItem]) {
        state.nasaItems += nasaItemData
        state.page += 10
        state.canLoadNextPage = nextPage
    }
    
    struct State {
        var nasaItems: [NASAItem] = []
        var page: Int = 10
        var canLoadNextPage = true
    }
    
    func refresh() {
        counter = 0
        nasaItems = []
        getMoreNASAPictures()
        state.canLoadNextPage = true
    }
    
    func loadImageFromURL(url: String, completion: @escaping (_ data: Data) -> () ) {
        guard let url = URL(string: url) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                completion(data)
            }
        }
        task.resume()
    }
    
    func saveImage(url: String, name: String) {
        print(url)
        var uiimg: UIImage?
        guard let url = URL(string: url) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async { [self] in
                uiimg = UIImage(data: data)
                guard let image = uiimg else { return }
                manager.saveImage(image: image, name: name)
            }
        }
        task.resume()
        
    }
    
    func getImageFromFileManager(name: String) -> UIImage? {
        return manager.getImage(name: name)
    }
    
    func deleteImage(name: String)  {
        manager.deleteImage(name: name)
    }
    
}




