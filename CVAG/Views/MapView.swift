//
//  MapView.swift
//  CVAG
//
//  Created by Jan Hülsmann on 31.12.21.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @ObservedObject var stopData = StopLoader()
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 50.830748,
            longitude: 12.921231),
        span: MKCoordinateSpan(
            latitudeDelta: 0.02,
            longitudeDelta: 0.02))
    
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: stopData.stops) { stop in
            MapMarker(coordinate: stop.coordinate)
        }.edgesIgnoringSafeArea(.all)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
