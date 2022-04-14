//
//  ListCell.swift
//  Nasa_project
//
//  Created by Justin Smith on 2022-04-11.
//

import SwiftUI

struct ListCell: View {
    
    var indexCount: Int
    var nasaData: NASAItem
    @ObservedObject var nasaViewModel: NASAViewModel
    @Binding var favouritesButton: Bool
    @Environment(\.managedObjectContext) var moc
    
    
    var body: some View {
        if !(nasaViewModel.nasaItems.isEmpty) {
            ZStack{
                GeometryReader { geo in
                    ZStack {
                        AsyncImage(url: URL(string: nasaData.nasaItem.url )) { image in
                            image.resizable()
                                .cornerRadius(10)
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geo.size.width, alignment: .center)
                        } placeholder: {
                            ZStack {
                                Color.white
                                ProgressView().foregroundColor(.black).font(.largeTitle)
                            }
                        }.frame(width: geo.size.width, height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        // Favourites Button (Star Button)
                        VStack {
                            HStack {
                                Spacer()
                                ZStack {
                                    StarButton(sfSymbolName: "star.fill", nasaDataIndex: indexCount, nasaViewModel: nasaViewModel, turnOnButton: $favouritesButton) {
                                        print(nasaData.nasaItem.title)
                                        if  nasaViewModel.nasaItems[indexCount].favourite == false {
                                            let favourite = Favourites(context: moc)
                                            favourite.id = UUID()
                                            favourite.title = nasaData.nasaItem.title
                                            favourite.url = nasaData.nasaItem.url
                                            favourite.isFavourite = true
                                            nasaViewModel.saveImage(url: nasaData.nasaItem.url, name: nasaData.nasaItem.title)
                                            try? moc.save()
                                            Haptics.createHaptics()
                                            nasaViewModel.nasaItems[indexCount].favourite = true
                                        }
                                    }
                                }
                            }
                            Spacer()
                        }
                    }.frame(width: geo.size.width * 0.98 , height: 200, alignment: .center)
                } // # End tag of Geometry Reader
            }.frame(height: 215)
            
        }
    }
}
