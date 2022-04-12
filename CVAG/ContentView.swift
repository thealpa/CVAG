//
//  ContentView.swift
//  CVAG
//
//  Created by Jan Hülsmann on 30.12.21.
//

import SwiftUI

struct ContentView: View {
    
    // Start with a placeholder stop
    @State var selectedStop: Stop = noStop
    @State var setDrawerHeight: drawerType = .hidden
    @State var showFavoritesView: Bool = true
    
    var body: some View {
        ZStack {
            MapView(selectedStop: $selectedStop, setDrawerHeight: $setDrawerHeight)
            DrawerView(selectedStop: $selectedStop, showFavoritesView: $showFavoritesView, setDrawerHeight: $setDrawerHeight, drawerHeights: [-100])
            FavoritesDrawerView(selectedStop: $selectedStop, setDrawerHeight: $setDrawerHeight, showFavoritesView: $showFavoritesView)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(selectedStop: Stop(id: 131, name: "Zentralhaltestelle", latitude: 50.1, longitude: 50.1), showFavoritesView: true)
    }
}
