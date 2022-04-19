//
//  Departure.swift
//  CVAG
//
//  Created by Jan Hülsmann on 04.01.22.
//

import Foundation

struct Departures: Codable {
    let stops: [Departure]
    let now: Int
}

struct Departure: Identifiable, Codable {
    let id = UUID()
    let destination: String?
    let serviceType: serviceType?
    let hasActualDeparture: Bool?
    let actualDeparture: Int
    let line: String?
    let platform: String?
    
    private enum CodingKeys: String, CodingKey {
        case destination
        case serviceType
        case hasActualDeparture
        case actualDeparture
        case line
        case platform
    }
}

enum serviceType: String, Codable {
    case bus = "BUS"
    case tram = "TRAM"
    case bahn = "CHEMNITZBAHN"
    case ev = "SCHIENENERSATZVERKEHR"
}
