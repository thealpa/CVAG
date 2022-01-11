//
//  StopAnnotationView.swift
//  CVAG
//
//  Created by Jan Hülsmann on 25.03.22.
//

import SwiftUI

struct StopAnnotationView: View {
    var stop: Stop
    @Binding var selectedStop: Stop
    @Binding var setDrawerHeight: drawerType
    
    var body: some View {
        Image(systemName: "mappin.circle.fill")
            .font(.title)
            .foregroundColor(.blue)
            .onTapGesture {
                setDrawerHeight = .medium
                selectedStop = stop
            }
    }
}

struct StopAnnotationView_Previews: PreviewProvider {
    static var previews: some View {
        StopAnnotationView(stop: (Stop(id: 131, name: "Zentralhaltestelle", latitude: 50.1, longitude: 50.1)), selectedStop: .constant(Stop(id: 131, name: "Zentralhaltestelle", latitude: 50.1, longitude: 50.1)), setDrawerHeight: .constant(.variable))
    }
}
