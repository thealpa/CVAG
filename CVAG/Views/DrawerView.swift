//
//  DrawerView.swift
//  CVAG
//
//  Created by Jan Hülsmann on 31.12.21.
//

import SwiftUI
import Drawer

struct DrawerView: View {
    var body: some View {
        Drawer(){
            
        }.rest(at: .constant([50, 300, UIScreen.main.bounds.height - 200]))
            .impact(.light)
            .spring(0)
    }
}

struct DrawerView_Previews: PreviewProvider {
    static var previews: some View {
        DrawerView()
    }
}
