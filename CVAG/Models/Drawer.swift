//
//  Drawer.swift
//  CVAG
//
//  Created by Jan Hülsmann on 02.01.22.
//

import SwiftUI

/// Default positions of drawer in __ascending__ order.
let drawerDefault: [CGFloat] = [(UIScreen.screenHeight * 0.15),
                                (UIScreen.screenHeight * 0.60),
                                (UIScreen.screenHeight * 0.90)]

public enum DrawerType {
    case hidden
    case variable
    case low
    case medium
    case high
}
