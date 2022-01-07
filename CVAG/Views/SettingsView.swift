//
//  SettingsView.swift
//  CVAG
//
//  Created by Jan Hülsmann on 17.03.22.
//

import SwiftUI

struct SettingsView: View {
    @Binding var showSettingsView: Bool
    
    var body: some View {
        NavigationView {
            SettingsViewContent()
                .navigationBarTitle("Settings", displayMode: .inline)
        }
    }
}

struct SettingsViewContent: View {
    var body: some View {
        Text("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(showSettingsView: .constant(true))
    }
}
