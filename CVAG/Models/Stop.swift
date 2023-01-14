//
//  TransportStop.swift
//  CVAG
//
//  Created by Jan Hülsmann on 01.01.22.
//

import MapKit

struct Stop: Identifiable, Codable, Equatable {
    let id: Int16
    let name: String
    let latitude: Double
    let longitude: Double

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
}

let noStop: Stop = Stop(id: 0, name: "", latitude: 0.0, longitude: 0.0)

typealias FavoriteStops = [Stop]

extension FavoriteStops: RawRepresentable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode(FavoriteStops.self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}
