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
            if departure.serviceType != nil {
                switch departure.serviceType! {
                case serviceType.bus:
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .frame(width: 45, height: 45)
                            .foregroundColor(Color(red: 0.44, green: 0.1, blue: 0.38))
                        Image(systemName: "bus.fill")
                            .font(.headline)
                            .foregroundColor(Color(.systemBackground))
                    }
                case serviceType.bahn:
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .frame(width: 45, height: 45)
                            .foregroundColor(Color(red: 0.12, green: 0.55, blue: 0.25))
                        Image(systemName: "tram.fill")
                            .font(.headline)
                            .foregroundColor(Color(.systemBackground))
                    }
                case serviceType.tram:
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .frame(width: 45, height: 45)
                            .foregroundColor(Color(red: 0.80, green: 0.07, blue: 0.09))
                        Image(systemName: "tram.fill")
                            .font(.headline)
                            .foregroundColor(Color(.systemBackground))
                    }
                case serviceType.ev:
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .frame(width: 45, height: 45)
                            .foregroundColor(Color(red: 0.93, green: 0.45, blue: 0.01))
                        Image(systemName: "bus.fill")
                            .font(.headline)
                            .foregroundColor(Color(.systemBackground))
                    }
                }
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .frame(width: 45, height: 45)
                        .foregroundColor(Color(red: 0.80, green: 0.07, blue: 0.09))
                    Image(systemName: "questionmark")
                        .font(.headline)
                        .foregroundColor(Color(.systemBackground))
                }
            }
            
            VStack(alignment: .leading) {
                HStack {
                    Text(departure.line ?? "")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text(departure.platform ?? "")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .opacity(0.6)
                        .offset(y: 3)
                }
                
                Text(departure.destination ?? "")
                    .font(.body)
                    .lineLimit(1)
                
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

func getAbsoluteTime(actualDeparture: Int) -> String {
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

func getRelativeTime(actualDeparture: Int) -> String {
    let date = NSDate(timeIntervalSince1970: Double(actualDeparture/1000))
    let currentDate = NSDate.now
    let difference = Calendar.current.dateComponents([.minute], from: currentDate, to: date as Date)
    
    return String(difference.minute!) + " min"
}

struct DepartureCellView_Previews: PreviewProvider {
    static var previews: some View {
        DepartureCellView(departure: Departure(destination: "Flemmingstr. ü. Klinikum", serviceType: serviceType.bus, hasActualDeparture: true, actualDeparture: 1647180720000, line: "31", platform: "5A"))
    }
}
