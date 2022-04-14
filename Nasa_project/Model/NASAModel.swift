//
//  Model.swift
//  Nasa_project
//
//  Created by Justin Smith on 2022-04-09.
//

import SwiftUI

struct NASA: Codable, Equatable {
    
    var date: String
    var explanation: String
    var title: String
    var url: String
    
}

struct NASAItem: Codable, Identifiable, Equatable {
    
    var id: Int
    var nasaItem: NASA
    var favourite: Bool
    
}

