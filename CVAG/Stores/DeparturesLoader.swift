//
//  DeparturesLoader.swift
//  CVAG
//
//  Created by Jan Hülsmann on 04.01.22.
//

import Foundation

final class DeparturesLoader: ObservableObject, @unchecked Sendable {
    @Published private(set) var departures = [Departure]()
    @Published private(set) var loadingError: Bool = false
    @Published private(set) var noDepartures: Bool = false

    func loadData(id: Int16) {
        // Skip if using placeholder id
        if id == 0 {
            return
        }

        let url = URL(string: "https://www.cvag.de/eza/mis/stops/station/CAG-" + String(id) + ".json")!
        print("Loading data from URL: " + url.absoluteString)
        let referrerURL = "http://www.cvag.de/eza/liste.html?station=CAG-" + String(id)
        var request = URLRequest(url: url)
        request.setValue(referrerURL, forHTTPHeaderField: "Referer")
        URLSession.shared.dataTask(with: request) {(data, _, error) in
            do {
                if let departureData = data {
                    let decodedData = try JSONDecoder().decode(Departures.self, from: departureData)
                    DispatchQueue.main.async {
                        self.loadingError = false
                        self.departures = decodedData.stops

                        if self.departures.isEmpty {
                            self.noDepartures = true
                        } else {
                            self.noDepartures = false
                        }
                    }
                } else {
                    print("No data")
                    DispatchQueue.main.async {
                        self.loadingError = true
                    }
                }
            } catch {
                print(error)
                DispatchQueue.main.async {
                    self.loadingError = true
                }
            }
        }.resume()
    }
}
