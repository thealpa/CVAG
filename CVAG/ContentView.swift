//
//  ContentView.swift
//  CVAG
//
//  Created by Jan Hülsmann on 30.12.21.
//

import SwiftUI


struct ContentView: View {
    @State var drawerHeight: drawerType = .variable
    
    var body: some View {
        ZStack {
            MapView(drawerHeight: $drawerHeight)
            DrawerView(drawerHeight: $drawerHeight, drawerHeights: drawerDefault)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
