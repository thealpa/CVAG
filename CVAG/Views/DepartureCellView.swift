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
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: 45, height: 45)
                
                if departure.serviceType == serviceType.tram || departure.serviceType == serviceType.bahn {
                    Image(systemName: "tram.fill")
                        .font(.headline)
                        .foregroundColor(Color(.systemBackground))
                } else if departure.serviceType == serviceType.bus {
                    Image(systemName: "bus.fill")
                        .font(.headline)
                        .foregroundColor(Color(.systemBackground))
                }
            }
            
            VStack(alignment: .leading) {
                Text(departure.line)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text(departure.destination)
                    .font(.body)
                
            }.padding(.leading, 10)

            Spacer()
            Text(useRelativeTime ? relativeTime : absoluteTime)
                .font(.title)
                .fontWeight(.medium)
                .onTapGesture {
                    useRelativeTime.toggle()
                }
        }.padding(.horizontal, 20)
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
