//
//  StopAnnotationView.swift
//  CVAG
//
//  Created by Jan Hülsmann on 25.03.22.
//

import SwiftUI

struct StopAnnotationView: View {
    let stop: Stop
    @Binding var selectedStop: Stop
    @Binding var setDrawerHeight: DrawerType
    @State private var showSelected: Bool = false

    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 12.0)
                    .foregroundColor(Color(.systemBackground))
                    .frame(width: 40, height: 40)

                Image("Haltestelle")
                    .resizable()
                    .frame(width: 25, height: 25)
            }

            Image(systemName: "arrowtriangle.down.fill")
                .font(.system(size: 10, weight: .black))
                .foregroundColor(Color(.systemBackground))
                .offset(x: 0, y: -5)

        }.compositingGroup()
        .scaleEffect(self.showSelected ? 1.8 : 1, anchor: .bottom)
        .animation(.interpolatingSpring(stiffness: 300, damping: 10), value: self.showSelected)
        .onTapGesture {
            self.setDrawerHeight = .medium
            self.selectedStop = self.stop
        }
        .onChange(of: self.selectedStop) { newStop in
            if self.stop.id != newStop.id {
                self.showSelected = false
            } else {
                self.showSelected.toggle()
            }
        }
    }
}

struct StopAnnotationView_Previews: PreviewProvider {
    static var previews: some View {
        StopAnnotationView(stop: (Stop(id: 131,
                                       name: "Zentralhaltestelle",
                                       latitude: 50.1,
                                       longitude: 50.1)),
                           selectedStop: .constant(Stop(id: 131,
                                                        name: "Zentralhaltestelle",
                                                        latitude: 50.1,
                                                        longitude: 50.1)),
                           setDrawerHeight: .constant(.variable))
    }
}
