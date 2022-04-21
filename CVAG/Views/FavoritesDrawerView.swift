//
//  FavoritesDrawerView.swift
//  CVAG
//
//  Created by Jan Hülsmann on 21.03.22.
//

import SwiftUI
import Drawer
import Introspect

struct FavoritesDrawerView: View {
    
    @Binding var selectedStop: Stop
    @Binding var setDrawerHeight: drawerType
    
    @StateObject var favoritesData = FavoritesModel()
    @Binding var showFavoritesView: Bool
    @State var restingHeight: [CGFloat] = drawerDefault
    @State var currentDrawerHeight: CGFloat = drawerDefault[1]
    
    //Workaround
    @State var showGrid: Bool = true
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
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
                        Text("Favoriten")
                              .frame(maxWidth: .infinity, alignment: .leading)
                              .font(.system(size: 32, weight: .semibold, design: .default))
                        
                        Spacer()
                        
                        Button {
                            showFavoritesView = false
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
                    
                    if showFavoritesView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(favoritesData.favorites) { favoriteStop in
                                
                                FavoriteButtonView(stop: favoriteStop)
                                    .contentShape(.dragPreview, RoundedRectangle(cornerRadius: 15))
                                    .opacity(favoritesData.currentFavorite?.id == favoriteStop.id ? 0.01 : 1)
                                    .onDrag({
                                        return NSItemProvider(object: String(favoriteStop.id) as NSString)
                                    })
                                    .onDrop(of: ["favorite"], delegate: DropViewDelegate(stop: favoriteStop, favoritesData: favoritesData))
                                    .onTapGesture {
                                        selectedStop = favoriteStop
                                        setDrawerHeight = .medium
                                        showFavoritesView = false
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
        .rest(at: $restingHeight)
        .onRest { restingHeight in
            currentDrawerHeight = restingHeight
        }
        .onChange(of: showFavoritesView) { showView in
            if showView == false {
                restingHeight = [-100]
            } else if showView == true {
                restingHeight = drawerDefault
            }
        }.ignoresSafeArea(.all)
    }
}

struct DropViewDelegate: DropDelegate {
    var stop: Stop
    var favoritesData: FavoritesModel
    
    func performDrop(info: DropInfo) -> Bool {
        favoritesData.currentFavorite = nil
        return true
    }
    
    func dropEntered(info: DropInfo) {
        
        if favoritesData.currentFavorite == nil {
            favoritesData.currentFavorite = stop
        }
        
        let fromIndex = favoritesData.favorites.firstIndex { (stop) -> Bool in
            return stop.id == favoritesData.currentFavorite?.id
        } ?? 0
        
        let toIndex = favoritesData.favorites.firstIndex { (stop) -> Bool in
            return stop.id == self.stop.id
        } ?? 0
        
        if fromIndex != toIndex {
            let fromStop = favoritesData.favorites[fromIndex]
            favoritesData.favorites[fromIndex] = favoritesData.favorites[toIndex]
            favoritesData.favorites[toIndex] = fromStop
        }
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
}

struct FavoritesDrawerView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesDrawerView(selectedStop: .constant(noStop), setDrawerHeight: .constant(.variable), showFavoritesView: .constant(true), restingHeight: [500] )
    }
}
