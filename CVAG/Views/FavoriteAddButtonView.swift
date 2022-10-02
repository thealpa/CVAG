//
//  FavoriteAddButtonView.swift
//  CVAG
//
//  Created by Jan Hülsmann on 11.04.22.
//

import SwiftUI

struct FavoriteAddButtonView: View {
    @StateObject var favoritesData = FavoritesModel()
    @State var isFavorite: Bool = false
    var stop: Stop
    var impactGenerator: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        
        Button {
            DispatchQueue.main.async {
                impactGenerator.impactOccurred()
            }
            if !favoritesData.favorites.contains(stop) {
                favoritesData.favorites.append(stop)
                isFavorite = true
            } else if let index = favoritesData.favorites.firstIndex(of: stop) {
                favoritesData.favorites.remove(at: index)
                isFavorite = false
            }
        } label: {
            HStack {
                if isFavorite == false {
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
        .onChange(of: stop) { newStop in
            if favoritesData.favorites.contains(newStop) {
                isFavorite = true
            } else {
                isFavorite = false
            }
        }         
    }
}

struct FavoriteAddButtonView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteAddButtonView(stop: Stop(id: 131, name: "Zentralhaltestelle", latitude: 50.1, longitude: 50.1))
    }
}
