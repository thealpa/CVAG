//
//  MapView.swift
//  CVAG
//
//  Created by Jan Hülsmann on 31.12.21.
//

import SwiftUI
import MapKit

struct MapView: View {
    @Binding var selectedStop: Stop
    @Binding var setDrawerHeight: DrawerType
    @ObservedObject private var stopData = StopLoader()

    private let region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 50.830748,
            longitude: 12.921231),
        span: MKCoordinateSpan(
            latitudeDelta: 0.02,
            longitudeDelta: 0.02)
    )

    var body: some View {
        Map(initialPosition: .region(self.region), bounds: .none, interactionModes: .all) {
            ForEach(self.stopData.stops) { stop in
                Annotation(stop.name, coordinate: stop.coordinate) {
                    StopAnnotationView(stop: stop,
                                       selectedStop: self.$selectedStop,
                                       setDrawerHeight: self.$setDrawerHeight)
                }
            }
        }.ignoresSafeArea()
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(selectedStop: .constant(Stop(id: 131,
                                             name: "Zentralhaltestelle",
                                             latitude: 50.1,
                                             longitude: 50.1)),
                setDrawerHeight: .constant(.variable))
    }
}
