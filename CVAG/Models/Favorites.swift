//
//  Favorites.swift
//  CVAG
//
//  Created by Jan Hülsmann on 09.04.22.
//

import SwiftUI

final class FavoritesModel: ObservableObject {
    @AppStorage("favoriteStops") var favorites = FavoriteStops()
    @Published var currentFavorite: Stop?

    private lazy var exampleFavorites: [Stop] = [
        Stop(id: 131, name: "Zentralhaltestelle", latitude: 50.8327427033286, longitude: 12.9213850148795),
        Stop(id: 216, name: "TU Campus", latitude: 50.8134653801663, longitude: 12.931050887338),
        Stop(id: 59, name: "Hauptbahnhof", latitude: 50.8400951572571, longitude: 12.929685448106)
    ]

    // Load example data on first run
    init() {
        if !UserDefaults.standard.bool(forKey: "didLaunchBefore") {
            UserDefaults.standard.set(true, forKey: "didLaunchBefore")
            self.favorites = self.exampleFavorites
        }
    }
}
