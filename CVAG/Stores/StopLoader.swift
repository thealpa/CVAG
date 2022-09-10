//
//  StopLoader.swift
//  CVAG
//
//  Created by Jan Hülsmann on 01.01.22.
//

import Foundation

class StopLoader: ObservableObject {
    @Published private(set) var stops = [Stop]()
        
    init() {
        loadData()
    }
    
    func loadData() {
        guard let url = Bundle.main.url(forResource: "Stops", withExtension: "json") else {
            print("JSON file not found")
            return
        }
        
        let data = try? Data(contentsOf: url)
        let stops = try? JSONDecoder().decode([Stop].self, from: data!)
        self.stops = stops!
    }
}
