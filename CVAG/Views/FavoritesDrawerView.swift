//
//  FavoritesDrawerView.swift
//  CVAG
//
//  Created by Jan Hülsmann on 21.03.22.
//

import SwiftUI
import Drawer

struct FavoritesDrawerView: View {
    @Binding var selectedStop: Stop
    @Binding var setDrawerHeight: DrawerType
    @Binding var showFavoritesView: Bool

    @StateObject private var favoritesData = FavoritesModel()
    @State private var restingHeight: [CGFloat] = drawerDefault
    @State private var currentDrawerHeight: CGFloat = drawerDefault[1]

    /// Haptics
    let impactGenerator: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    let dislodgeGenerator: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)

    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)

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
                        Text("Favorites")
                              .frame(maxWidth: .infinity, alignment: .leading)
                              .font(.system(size: 32, weight: .semibold, design: .default))

                        Spacer()

                        Button {
                            self.showFavoritesView = false
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

                    if self.showFavoritesView {
                        LazyVGrid(columns: self.columns, spacing: 20) {
                            ForEach(self.favoritesData.favorites) { favoriteStop in
                                FavoriteButtonView(stop: favoriteStop)
                                    .contentShape(.dragPreview, RoundedRectangle(cornerRadius: 15))
                                    .opacity(self.favoritesData.currentFavorite?.id == favoriteStop.id ? 0.01 : 1)
                                    .onDrag({
                                        return NSItemProvider(object: String(favoriteStop.id) as NSString)
                                    })
                                    .onDrop(of: ["favorite"],
                                            delegate: DropViewDelegate(
                                                stop: favoriteStop,
                                                favoritesData: self.favoritesData
                                            )
                                    )
                                    .onTapGesture {
                                        self.selectedStop = favoriteStop
                                        self.setDrawerHeight = .medium
                                        self.showFavoritesView = false
                                    }
                            }
                        }.padding(.horizontal, 15)
                    }

                    Spacer()
                }
            }
        }.impact(.medium)
        .dislodge(.light)
        .spring(0)
        .rest(at: self.$restingHeight)
        .onRest { restingHeight in
            self.currentDrawerHeight = restingHeight
        }
        .onChange(of: self.showFavoritesView) { showView in
            if showView == false {
                self.restingHeight = [-10]
                DispatchQueue.main.async {
                    self.dislodgeGenerator.impactOccurred()
                }
            } else if showView == true {
                self.restingHeight = drawerDefault
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.impactGenerator.impactOccurred()
                }
            }
        }.ignoresSafeArea(.all)
    }
}

struct DropViewDelegate: DropDelegate {
    var stop: Stop
    var favoritesData: FavoritesModel

    func performDrop(info: DropInfo) -> Bool {
        self.favoritesData.currentFavorite = nil
        return true
    }

    func dropEntered(info: DropInfo) {

        if self.favoritesData.currentFavorite == nil {
            self.favoritesData.currentFavorite = stop
        }

        let fromIndex = self.favoritesData.favorites.firstIndex { (stop) -> Bool in
            return stop.id == self.favoritesData.currentFavorite?.id
        } ?? 0

        let toIndex = self.favoritesData.favorites.firstIndex { (stop) -> Bool in
            return stop.id == self.stop.id
        } ?? 0

        if fromIndex != toIndex {
            let fromStop = self.favoritesData.favorites[fromIndex]
            self.favoritesData.favorites[fromIndex] = self.favoritesData.favorites[toIndex]
            self.favoritesData.favorites[toIndex] = fromStop
        }
    }

    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
}

struct FavoritesDrawerView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesDrawerView(selectedStop: .constant(noStop),
                            setDrawerHeight: .constant(.variable),
                            showFavoritesView: .constant(true))
    }
}
