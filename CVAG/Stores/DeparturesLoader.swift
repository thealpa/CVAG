//
//  DeparturesLoader.swift
//  CVAG
//
//  Created by Jan Hülsmann on 04.01.22.
//

import Foundation

class DeparturesLoader: ObservableObject {
    @Published var departures = [Departure]()
        
    init(id: Int16){
        loadData()
    }
    
    func loadData()  {
        let url = URL(string: "https://www.cvag.de/eza/mis/stops/station/CAG-131.json")!
        let referrerURL = "http://www.cvag.de/eza/liste.html?station=CAG-131"
        var request = URLRequest(url: url)
        request.setValue(referrerURL, forHTTPHeaderField: "Referer")
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            do {
                if let departureData = data {
                    let decodedData = try JSONDecoder().decode(DeparturesTest.self, from: departureData)
                    DispatchQueue.main.async {
                        self.departures = decodedData.stops
                    }
                } else {
                    print("No data")
                }
            } catch {
                print("Error")
                print(error)
            }
        }.resume()
    }
}
