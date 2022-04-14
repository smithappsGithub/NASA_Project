//
//  ListView.swift
//  Nasa_project
//
//  Created by Justin Smith on 2022-04-11.
//

import SwiftUI

struct NASAListView: View {
    
    let nasaItems: [NASAItem]
    let onScrolledAtBottom: () -> Void
    let isLoading: Bool
    @Binding var favouritesButton: Bool
    @Binding var search: String
    @ObservedObject var nasaViewmodel: NASAViewModel
    
    var body: some View {
        List {
            nasaListSearchAndFilter
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            if isLoading {
                HStack(alignment: .center) {
                    Spacer()
                    ProgressView()
                    Spacer()
                }.listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
            }
        }
        .searchable(text: $search, placement: .navigationBarDrawer(displayMode: .automatic), prompt: Text("Filter by topic"))
        .statusBar(hidden: true)
        
    }
    
    private var nasaListSearchAndFilter: some View {
        
        ForEach(Array(nasaViewmodel.nasaItems.filter { $0.nasaItem.title.contains(search) || search == ""}.enumerated()), id: \.offset) { index, item in
            
            ListCell(
                indexCount: index,
                nasaData: item,
                nasaViewModel: nasaViewmodel,
                favouritesButton: $favouritesButton)
            
                .onAppear {
                    if self.nasaViewmodel.nasaItems.last == item {
                        self.onScrolledAtBottom()
                        nasaViewmodel.nextPage = true
                    }
                }
        }
    }
}
