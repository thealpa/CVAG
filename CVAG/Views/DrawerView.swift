//
//  DrawerView.swift
//  CVAG
//
//  Created by Jan Hülsmann on 31.12.21.
//

import SwiftUI
import Drawer

struct DrawerView: View {
    
    @Binding var drawerHeight: drawerType
    @State var drawerHeights: [CGFloat]
    
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
                RoundedRectangle(cornerRadius: 30.0)
                    .foregroundColor(Color(.systemGray6))
                    .opacity(0.95)
                    .shadow(radius: 50)
                
                VStack {
                    Spacer().frame(height: 8.0)
                    RoundedRectangle(cornerRadius: 3.0)
                        .foregroundColor(.gray)
                        .frame(width: 35.0, height: 6.0)
                    
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
        DrawerView(drawerHeight: .constant(.variable), drawerHeights: drawerDefault)
    }
}
