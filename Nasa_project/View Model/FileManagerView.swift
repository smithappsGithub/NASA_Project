//
//  FileManagerView.swift
//  Nasa_project
//
//  Created by Justin Smith on 2022-04-10.
//

import SwiftUI

class LocalFileManager {
    
    static let instance = LocalFileManager()
    
    func saveImage(image: UIImage, name: String) {
        guard let data = image.jpegData(compressionQuality: 1.0),
              let path = getPathLogic(name: name) else {
                  print("Error saving image to documents")
                  return
              }
        do {
            try data.write(to: path)
            print("Picture was successfully saved to file")
        } catch let error {
            print("error saving \(error)")
        }
    }
    
    func getImage(name: String) -> UIImage? {
        guard let path = getPathLogic(name: name)?.path,
              FileManager.default.fileExists(atPath: path) else {
                  return nil
              }
        return UIImage(contentsOfFile: path)
    }
    
    func getPathLogic(name: String) -> URL? {
        guard let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("\(name).jpg") else {
            print("Error")
            return nil
        }
        return path
    }
    
    func deleteImage(name: String) {
        guard let path = getPathLogic(name: name),
              FileManager.default.fileExists(atPath: path.path) else {
                  print("error deleting use xctests")
                  return
              }
        do {
            try FileManager.default.removeItem(at: path)
            print("deleted xctests")
        } catch let error {
            print("there was an error deleting: \(error)")
            
        }
    }
}
















