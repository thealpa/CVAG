//
//  TransportStop.swift
//  CVAG
//
//  Created by Jan Hülsmann on 01.01.22.
//

import Foundation
import MapKit

struct Stop: Identifiable, Codable, Equatable {
    let id: Int16
    let name: String
    let latitude: Double
    let longitude: Double

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

let noStop: Stop = Stop(id: 0, name: "", latitude: 0.0, longitude: 0.0)
