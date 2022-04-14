//
//  FavouritesView.swift
//  Nasa_project
//
//  Created by Justin Smith on 2022-04-09.
//

import SwiftUI

struct FavouritesView: View {
    
    @State private var turnOnTrashButton: Bool = true
    @ObservedObject var nasaViewModel: NASAViewModel
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var favourites: FetchedResults<Favourites>
    
    @State var turnOnDelete: Bool = false
    
    var body: some View {
        VStack {
            if favourites.isEmpty {
                Text("No favourites to display").bold().foregroundColor(.gray)
            }
            ScrollView(.vertical, showsIndicators: false) {
                forEachItemInFavourites
            }
        }
        .navigationBarTitle("Favourites")
        .navigationBarItems(leading: Text(""), trailing: Button(action: {
            self.turnOnDelete.toggle()}) {
                HStack {
                    Image(systemName: "trash.fill").font(.title3)
                        .foregroundColor(turnOnDelete ? .red : .blue)
                }})
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
    
    var forEachItemInFavourites: some View {
        ForEach(favourites.indices, id: \.self) { index in
            ZStack
            {
                if let image = nasaViewModel.getImageFromFileManager(name: favourites[index].title ?? "") {
                    Image(uiImage: image).resizable().aspectRatio(contentMode: .fill).frame(width: width * 0.9, height: 200).cornerRadius(15)
                        .shadow(color: .init(red: 0.1, green: 0.1, blue: 0.1), radius: 3, x: 0, y: 3)
                } else {
                    ZStack {
                        Rectangle().frame(width: width * 0.9, height: 200).cornerRadius(15)
                        Text("Could not be displayed").bold().foregroundColor(.white).font(.subheadline)
                    }
                }
                // Functionality (Trash Icon and Delete)
                if turnOnDelete {
                    VStack {
                        HStack {
                            Spacer()
                            ZStack {
                                Button(action: {
                                    nasaViewModel.deleteImage(name: favourites[index].title ?? "")
                                    moc.delete(favourites[index])
                                    Haptics.createHaptics()
                                    try? moc.save() }
                                ) {
                                    Image(systemName: "trash.fill")
                                        .foregroundColor(turnOnDelete  ? .red : .white).disabled(turnOnDelete)
                                        .font(.title)
                                        .opacity(1.0)
                                        .padding(5)
                                        .background(.ultraThinMaterial)
                                        .mask(Circle())
                                } .padding()
                                    .padding(.horizontal)
                            }
                        }
                        Spacer()
                    }
                }
            }.padding()
            
        }.onDelete(perform: deleteFavouriteImage)
    }
    
    func deleteFavouriteImage(at offsets: IndexSet) {
        for offset in offsets {
            let favouriteImage = favourites[offset]
            moc.delete(favouriteImage)
        }
        try? moc.save()
    }
}

struct FavouritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavouritesView(nasaViewModel: NASAViewModel())
    }
}




