//
//  DepartureView.swift
//  CVAG
//
//  Created by Jan Hülsmann on 13.03.22.
//

import SwiftUI

struct DepartureCellView: View {
    
    // Store whether to use absolute or relative departure times
    @AppStorage("useRelativeTime") var useRelativeTime: Bool = false
    
    var departure: Departure
    
    var body: some View {
        let absoluteTime: String = getAbsoluteTime(actualDeparture: departure.actualDeparture)
        
        let relativeTime: String = getRelativeTime(actualDeparture: departure.actualDeparture)
        
        HStack {
            Text(departure.line)
            Text(departure.destination)
            Spacer()
            Text(useRelativeTime ? relativeTime : absoluteTime)
                .onTapGesture {
                    useRelativeTime.toggle()
                }
        }.padding()
    }
}

func getAbsoluteTime (actualDeparture: Int) -> String {
    let date = NSDate(timeIntervalSince1970: Double(actualDeparture/1000))
    let calendar = Calendar.current
    let hour = calendar.component(.hour, from: date as Date)
    let minute = calendar.component(.minute, from: date as Date)
    if minute <= 9 {
        return String(hour) + ":0" + String(minute)
    } else {
        return String(hour) + ":" + String(minute)
    }
}

func getRelativeTime (actualDeparture: Int) -> String {
    let date = NSDate(timeIntervalSince1970: Double(actualDeparture/1000))
    let currentDate = NSDate.now
    let difference = Calendar.current.dateComponents([.minute], from: currentDate, to: date as Date)
    
    return String(difference.minute!) + " min"
}

struct DepartureCellView_Previews: PreviewProvider {
    static var previews: some View {
        DepartureCellView(departure: Departure(destination: "Flemmingstr. ü. Klinikum", serviceType: serviceType.bus, hasActualDeparture: true, actualDeparture: 1647180720000, line: "31", platform: ""))
    }
}
