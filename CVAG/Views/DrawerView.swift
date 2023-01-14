//
//  DrawerView.swift
//  CVAG
//
//  Created by Jan Hülsmann on 31.12.21.
//

import SwiftUI
import Drawer

struct DrawerView: View, Sendable {
    @Binding var selectedStop: Stop
    @StateObject private var departuresList = DeparturesLoader()
    @Binding var showFavoritesView: Bool
    @Binding var setDrawerHeight: DrawerType
    @State var drawerHeights: [CGFloat]
    @State private var currentDrawerHeight: CGFloat = drawerDefault[1]
    @State private var showError = false
    @State private var noDepartures = false
    @State private var scrollFits = false

    /// Update timer
    private let timer = Timer.publish(every: 30, tolerance: 5, on: .main, in: .common).autoconnect()

    /// Haptics
    private let impactGenerator: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    private let dislodgeGenerator: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)

    /// Sets the drawer height
    func changeHeight(newHeight: DrawerType) {

        if newHeight != .variable {
            DispatchQueue.main.async {
                self.dislodgeGenerator.impactOccurred()
            }

            var tempDrawerHeight = self.drawerHeights

            switch newHeight {
            case .hidden:
                tempDrawerHeight = [-10]
            case .low:
                tempDrawerHeight = [drawerDefault.first!]
            case .medium:
                tempDrawerHeight = [drawerDefault[drawerDefault.count / 2]]
            case .high:
                tempDrawerHeight = [drawerDefault.last!]
            case .variable:
                break
            }

            if currentDrawerHeight != tempDrawerHeight[0]  && self.setDrawerHeight != .hidden {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.impactGenerator.impactOccurred()
                }
            }

            self.drawerHeights = tempDrawerHeight
        }

        if self.drawerHeights != drawerDefault && self.setDrawerHeight != .hidden {
            DispatchQueue.global(qos: .background).async {
                let second: Double = 1_000_000
                usleep(useconds_t(0.3 * second))
                DispatchQueue.main.async {
                    self.drawerHeights = drawerDefault
                    self.setDrawerHeight = .variable
                }
            }
        }
    }

    var body: some View {
        Drawer {
            ZStack {

                RoundedRectangle(cornerRadius: UIScreen.main.displayCornerRadius, style: .continuous)
                    .foregroundColor(Color(.systemBackground))
                    .shadow(radius: 25)

                VStack {
                    Spacer().frame(height: 8.0)

                    RoundedRectangle(cornerRadius: 3.0)
                        .foregroundColor(Color(.systemGray5))
                        .frame(width: 35.0, height: 6.0)

                    HStack {
                        Text(self.selectedStop.name)
                              .frame(maxWidth: .infinity, alignment: .leading)
                              .font(.system(size: 32, weight: .semibold, design: .default))
                              .lineLimit(1)

                        Spacer()

                        Button {
                            self.setDrawerHeight = .hidden
                            self.selectedStop = noStop
                            self.showFavoritesView = true
                        } label: {
                            ZStack {
                                Circle()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(Color(.secondarySystemBackground))
                                Image(systemName: "xmark")
                                    .font(.system(size: 12, weight: .bold, design: .rounded))
                                    .foregroundColor(Color(.secondaryLabel))
                            }
                        }

                    }.padding(.horizontal, 20)
                        .padding(.top, 15)
                        .padding(.bottom, 20)

                    if self.showError {
                        Image(systemName: "wifi.exclamationmark")
                            .font(.system(size: 48))
                            .foregroundColor(Color(.systemRed))
                            .padding(.top, 100)
                        Text("NoConnection")
                            .font(.footnote)
                            .padding()
                    } else if self.noDepartures {
                        Image(systemName: "moon.zzz.fill")
                            .font(.system(size: 48))
                            .foregroundColor(Color(.systemGray))
                            .padding(.top, 100)
                        Text("NoDepartures")
                            .font(.footnote)
                            .padding()
                    } else {
                        GeometryReader { proxy in
                            ScrollView(.vertical, showsIndicators: true) {
                                ForEach(self.departuresList.departures) { departure in
                                    DepartureCellView(departure: departure)
                                    Divider()
                                        .padding(.horizontal, 20)
                                        .padding(.bottom, 10)
                                }.background {
                                    GeometryReader {
                                        Color.clear.preference(
                                            key: ViewHeightKey.self,
                                            value: $0.frame(in: .local).size.height
                                        )
                                    }
                                }
                            }.onPreferenceChange(ViewHeightKey.self) {
                                self.scrollFits = $0 < proxy.size.height
                            }.disabled(self.scrollFits)
                        }.onReceive(self.timer) { _ in

                            // Only reload data if drawer is visible
                            if self.currentDrawerHeight > 0 {
                                self.departuresList.loadData(id: self.selectedStop.id)
                            }
                        }
                    }

                    Spacer()
                }

                FavoriteAddButtonView(stop: self.selectedStop)
                    .shadow(radius: 5)
                    .padding(.top, drawerDefault[2] - 200)

            }
        }.impact(.medium)
        .dislodge(.light)
        .spring(0)
        .rest(at: self.$drawerHeights)
        .onRest { restingHeight in
            self.currentDrawerHeight = restingHeight
        }
        .onChange(of: self.setDrawerHeight) { newHeight in
            self.changeHeight(newHeight: newHeight)
        }
        .onChange(of: self.departuresList.loadingError) { newValue in
            self.showError = newValue
        }
        .onChange(of: self.departuresList.noDepartures) { newValue in
            self.noDepartures = newValue
        }
        .onChange(of: self.selectedStop) { newStop in
            self.departuresList.loadData(id: self.selectedStop.id)
            if newStop != noStop {
                self.showFavoritesView = false
            }
        }.ignoresSafeArea(.all)
    }

    private struct ViewHeightKey: PreferenceKey {
        static var defaultValue: CGFloat { 0 }
        static func reduce(value: inout Value, nextValue: () -> Value) {
            value += nextValue()
        }
    }
}

struct DrawerView_Previews: PreviewProvider {
    static var previews: some View {
        DrawerView(
            selectedStop: .constant(
                Stop(
                    id: 131,
                    name: "Zentralhaltestelle",
                    latitude: 50.1,
                    longitude: 50.1)
            ),
            showFavoritesView: .constant(false),
            setDrawerHeight: .constant(.variable),
            drawerHeights: [drawerDefault.last!]
        )
    }
}
