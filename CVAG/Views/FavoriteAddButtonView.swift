//
//  FavoriteAddButtonView.swift
//  CVAG
//
//  Created by Jan Hülsmann on 11.04.22.
//

import SwiftUI

struct FavoriteAddButtonView: View {
    let stop: Stop

    @StateObject private var favoritesData = FavoritesModel()
    @State private var isFavorite: Bool = false
    private let impactGenerator: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)

    var body: some View {
        Button {
            DispatchQueue.main.async {
                self.impactGenerator.impactOccurred()
            }
            if !self.favoritesData.favorites.contains(stop) {
                self.favoritesData.favorites.append(stop)
                self.isFavorite = true
            } else if let index = self.favoritesData.favorites.firstIndex(of: self.stop) {
                self.favoritesData.favorites.remove(at: index)
                self.isFavorite = false
            }
        } label: {
            HStack {
                if self.isFavorite == false {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                    Text("AddToFavorites")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                } else {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                    Text("RemoveFromFavorites")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                }

            }
            .padding(.horizontal, 20)
            .padding(.vertical, 5)
        }
        .foregroundColor(Color(.systemBackground))
        .padding()
        .background(Color(.label))
        .clipShape(Capsule())
        .onChange(of: self.stop) { newStop in
            if self.favoritesData.favorites.contains(newStop) {
                self.isFavorite = true
            } else {
                self.isFavorite = false
            }
        }
    }
}

struct FavoriteAddButtonView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteAddButtonView(stop: Stop(id: 131, name: "Zentralhaltestelle", latitude: 50.1, longitude: 50.1))
    }
}
