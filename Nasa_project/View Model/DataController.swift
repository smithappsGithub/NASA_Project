//
//  DataController.swift
//  Nasa_project
//
//  Created by Justin Smith on 2022-04-09.
//

import SwiftUI
import CoreData

class DataController: ObservableObject {
    
    let container = NSPersistentContainer(name: "NASADataModel")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}

