//
//  FavoriteButtonView.swift
//  CVAG
//
//  Created by Jan Hülsmann on 10.04.22.
//

import SwiftUI

struct FavoriteButtonView: View {
    var stop: Stop

    var body: some View {
        VStack {
            HStack {
                Image(systemName: "mappin.and.ellipse")
                    .font(Font.system(size: 20, weight: .semibold, design: .rounded))
                    .padding(.horizontal, 15)
                    .padding(.top, 15)

                Spacer()
            }

            Spacer()

            HStack {
                Text(stop.name)
                    .font(Font.system(size: 20, weight: .semibold, design: .rounded))
                    .padding(.horizontal, 15)
                    .padding(.bottom, 15)

                Spacer()
            }
        }
        .frame(width: (UIScreen.screenWidth - 60) / 2, height: 120)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(15)
    }
}

struct FavoriteButtonView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteButtonView(stop: Stop(id: 131, name: "Zentralhaltestelle", latitude: 50.1, longitude: 50.1))
    }
}
