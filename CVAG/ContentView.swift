//
//  ContentView.swift
//  CVAG
//
//  Created by Jan Hülsmann on 30.12.21.
//

import SwiftUI

struct ContentView: View {
    
    // Start with a placeholder stop
    @State var selectedStop: Stop = Stop(id: 0, name: "-", latitude: 0, longitude: 0)
    @State var setDrawerHeight: drawerType = .hidden
    
    var body: some View {
        ZStack {
            MapView(selectedStop: $selectedStop, setDrawerHeight: $setDrawerHeight)
            DrawerView(selectedStop: $selectedStop, setDrawerHeight: $setDrawerHeight, drawerHeights: [-100])
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(selectedStop: Stop(id: 131, name: "Zentralhaltestelle", latitude: 50.1, longitude: 50.1))
    }
}
