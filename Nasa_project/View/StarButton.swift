//
//  StarButton.swift
//  Nasa_project
//
//  Created by Justin Smith on 2022-04-09.
//

import SwiftUI

struct StarButton: View {
    
    var sfSymbolName: String
    var nasaDataIndex: Int
    @ObservedObject var nasaViewModel: NASAViewModel
    @Binding var turnOnButton: Bool
    var content: () -> Void
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        ZStack {
            VStack {
                Button(action: {
                    content()
                } ) {
                    if !(nasaViewModel.nasaItems.isEmpty) {
                        Image(systemName: sfSymbolName)
                            .foregroundColor(nasaViewModel.nasaItems[nasaDataIndex].favourite ? .yellow : .white)
                            .opacity(nasaViewModel.nasaItems[nasaDataIndex].favourite ? 0.7 : 1.0)
                            .font(.title)
                            .opacity(1)
                            .padding(4)
                            .background(.ultraThinMaterial)
                            .mask(Circle())
                    }
                }.padding()
                    .buttonStyle(PlainButtonStyle())
            }
        }
    }
}
