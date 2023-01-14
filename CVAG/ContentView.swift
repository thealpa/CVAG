//
//  ContentView.swift
//  CVAG
//
//  Created by Jan Hülsmann on 30.12.21.
//

import SwiftUI

struct ContentView: View {

    // Start with a placeholder stop
    @State private var selectedStop: Stop = noStop
    @State private var setDrawerHeight: DrawerType = .hidden
    @State private var showFavoritesView: Bool = true

    var body: some View {
        ZStack {
            MapView(
                selectedStop: self.$selectedStop,
                setDrawerHeight: self.$setDrawerHeight
            )

            DrawerView(
                selectedStop: self.$selectedStop,
                showFavoritesView: self.$showFavoritesView,
                setDrawerHeight: self.$setDrawerHeight,
                drawerHeights: [-100]
            )

            FavoritesDrawerView(
                selectedStop: self.$selectedStop,
                setDrawerHeight: self.$setDrawerHeight,
                showFavoritesView: self.$showFavoritesView
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
