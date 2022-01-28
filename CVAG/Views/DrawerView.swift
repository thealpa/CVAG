//
//  DrawerView.swift
//  CVAG
//
//  Created by Jan Hülsmann on 31.12.21.
//

import SwiftUI
import Drawer
import Introspect

struct DrawerView: View {
    
    @Binding var selectedStop: Stop
    @StateObject var departuresList = DeparturesLoader()
    @Binding var setDrawerHeight: drawerType
    @State var drawerHeights: [CGFloat]
    @State var currentDrawerHeight: CGFloat = drawerDefault[1]
    
    /// Haptics
    var impactGenerator: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    var dislodgeGenerator: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    /// Sets the drawer height
    func changeHeight(newHeight: drawerType) -> Void {
        
        if newHeight != .variable {
            DispatchQueue.main.async {
                dislodgeGenerator.impactOccurred()
            }
            
            var tempDrawerHeight = drawerHeights

            switch newHeight {
            case .hidden:
                tempDrawerHeight = [-100]
            case .low:
                tempDrawerHeight = [drawerDefault.first!]
            case .medium:
                tempDrawerHeight = [drawerDefault[drawerDefault.count / 2]]
            case .high:
                tempDrawerHeight = [drawerDefault.last!]
            case .variable:
                break
            }
            
            if currentDrawerHeight != tempDrawerHeight[0]  && setDrawerHeight != .hidden {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    impactGenerator.impactOccurred()
                }
            }
            
            drawerHeights = tempDrawerHeight
        }
        
        // TODO: A better solution would be to wait until animation is finished
        if drawerHeights != drawerDefault && setDrawerHeight != .hidden {
            DispatchQueue.global(qos: .background).async {
                let second: Double = 1000000
                usleep(useconds_t(0.3 * second))
                DispatchQueue.main.async {
                    drawerHeights = drawerDefault
                    setDrawerHeight = .variable
                }
            }
        }
    }
    
    var body: some View {
        Drawer(){
            ZStack {
                
                RoundedRectangle(cornerRadius: 50.0)
                    .foregroundColor(Color(.systemBackground))
                    .shadow(radius: 25)
                
                VStack {
                    Spacer().frame(height: 8.0)
                    
                    RoundedRectangle(cornerRadius: 3.0)
                        .foregroundColor(Color(.systemGray5))
                        .frame(width: 35.0, height: 6.0)
                    
                    HStack {
                        Text(selectedStop.name)
                              .frame(maxWidth: .infinity, alignment: .leading)
                              .font(.system(size: 32, weight: .semibold, design: .default))
                              .lineLimit(1)
                              .animation(Animation.linear(duration: 0.1), value: selectedStop)
                        
                        Spacer()
                        
                        ZStack {
                            Circle()
                                .frame(width: 25, height: 25)
                                .foregroundColor(Color(.secondarySystemBackground))
                            Button {
                                setDrawerHeight = .hidden
                            } label: {
                                Image(systemName: "xmark")
                                    .font(.system(size: 12, weight: .bold, design: .rounded))
                                    .foregroundColor(Color(.secondaryLabel))
                            }
                        }
                        
                    }.padding(.horizontal, 20)
                        .padding(.top, 15)
                        .padding(.bottom, 20)
                    
                    ScrollView {
                        ForEach(departuresList.departures) { departure in
                            DepartureCellView(departure: departure)
                            Divider()
                                .padding(.horizontal, 20)
                                .padding(.bottom, 10)
                        }
                    }.onChange(of: selectedStop) { newStop in
                        departuresList.loadData(id: selectedStop.id)
                    }.introspectScrollView { scrollView in
                        scrollView.alwaysBounceVertical = false
                    }
                    .frame(maxHeight: UIScreen.main.bounds.height - 270)
                    
                    Spacer()
                }
            }
        }.impact(.medium)
        .dislodge(.light)
        .spring(0)
        .rest(at: $drawerHeights)
        .onRest { restingHeight in
            currentDrawerHeight = restingHeight
        }
        .onChange(of: setDrawerHeight) {newValue in
            changeHeight(newHeight: newValue)
        }
    }
}

struct DrawerView_Previews: PreviewProvider {
    static var previews: some View {
        DrawerView(selectedStop: .constant(Stop(id: 131, name: "Zentralhaltestelle", latitude: 50.1, longitude: 50.1)), setDrawerHeight: .constant(.variable), drawerHeights: [drawerDefault.last!])
    }
}
