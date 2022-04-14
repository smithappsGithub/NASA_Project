//
//  ListSetup.swift
//  Nasa_project
//
//  Created by Justin Smith on 2022-04-11.
//

import SwiftUI

struct HomeView: View {
    
    @State private var favouritesButton: Bool = true
    private let itemHeight: CFloat = 500
    @State var search = ""
    @ObservedObject var nasaViewModel = NASAViewModel()
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var favourites: FetchedResults<Favourites>
    
    var body: some View {
        NavigationView {
            VStack{
                NASAListView(nasaItems: nasaViewModel.state.nasaItems,
                             onScrolledAtBottom: nasaViewModel.getMoreNASAPictures,
                             isLoading: nasaViewModel.state.canLoadNextPage,
                             favouritesButton: $favouritesButton,
                             search: $search,
                             nasaViewmodel: nasaViewModel)
                    .onAppear(perform: nasaViewModel.getMoreNASAPictures)
                    .refreshable {
                        nasaViewModel.refresh()
                    }
                    .navigationBarTitle("NASA")
                    .navigationBarItems(leading: Text(""), trailing:
                                            NavigationLink(destination: FavouritesView(nasaViewModel: nasaViewModel)) {
                        HStack {
                            Image(systemName: "folder.fill").font(.title3)
                                .foregroundColor(.blue)
                        }})
                    .navigationViewStyle(StackNavigationViewStyle())
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
