//
//  TransportStop.swift
//  CVAG
//
//  Created by Jan Hülsmann on 01.01.22.
//

import Foundation
import MapKit

struct Stop: Identifiable, Codable {
    let id: Int16
    let name: String
    let latitude: Double
    let longitude: Double

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
