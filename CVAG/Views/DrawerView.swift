//
//  DrawerView.swift
//  CVAG
//
//  Created by Jan Hülsmann on 31.12.21.
//

import SwiftUI
import Drawer

struct DrawerView: View {
    
    @Binding var selectedStop: Stop
    @StateObject var departuresList = DeparturesLoader()
    @Binding var drawerHeight: drawerType
    @State var drawerHeights: [CGFloat]
    @State var showSettingsView: Bool = false
    
    /// Sets the drawer height
    func changeHeight(newHeight: drawerType) -> Void {
        
        switch newHeight {
        case .low:
            drawerHeights = [drawerDefault.first!]
        case .medium:
            drawerHeights = [drawerDefault[drawerDefault.count / 2]]
        case .high:
            drawerHeights = [drawerDefault.last!]
        case .variable:
            break
        }
        
        // TODO: A better solution would be to wait until animation is finished
        if drawerHeights != drawerDefault {
            DispatchQueue.global(qos: .background).async {
                let second: Double = 1000000
                usleep(useconds_t(0.5 * second))
                DispatchQueue.main.async {
                    drawerHeights = drawerDefault
                    drawerHeight = .variable
                }
            }
        }
    }
    
    var body: some View {
        Drawer(){
            ZStack {
                RoundedRectangle(cornerRadius: 50.0)
                    .foregroundColor(Color(.systemBackground))
                    //.opacity(0.95)
                    .shadow(radius: 50)
                
                VStack {
                    Spacer().frame(height: 8.0)
                    
                    RoundedRectangle(cornerRadius: 3.0)
                        .foregroundColor(Color(.systemGray5))
                        .frame(width: 35.0, height: 6.0)
                    
                    Text(selectedStop.name)
                          .frame(maxWidth: .infinity, alignment: .leading) // << full width
                          .font(.system(size: 30, weight: .semibold, design: .default))
                          .padding()
                    
                    List {
                        ForEach(departuresList.departures) { departure in
                            DepartureCellView(departure: departure)
                        }
                    }.listStyle(.inset)
                        .onChange(of: selectedStop) {newStop in
                        departuresList.loadData(id: selectedStop.id)
                        }
                        .frame(maxHeight: UIScreen.main.bounds.height - 300)
                    
                    Button(action: {showSettingsView.toggle()}) {
                        Text("Settings")
                    }.sheet(isPresented: $showSettingsView) {
                        SettingsView(showSettingsView: self.$showSettingsView)
                    }
                    
                    Spacer()
                }
            }
        }   .impact(.light)
            .spring(0)
            .rest(at: $drawerHeights)
            .onChange(of: drawerHeight) {newValue in
                changeHeight(newHeight: newValue)
            }
    }
}

struct DrawerView_Previews: PreviewProvider {
    static var previews: some View {
        DrawerView(selectedStop: .constant(Stop(id: 131, name: "Zentralhaltestelle", latitude: 50.1, longitude: 50.1)), drawerHeight: .constant(.variable), drawerHeights: [drawerDefault.last!])
    }
}
