//
//  Drawer.swift
//  CVAG
//
//  Created by Jan Hülsmann on 02.01.22.
//

import SwiftUI

/// Default positions of drawer in __ascending__ order.
let drawerDefault: [CGFloat] = [50, 400, UIScreen.main.bounds.height - 150]

public enum drawerType {
    case variable
    case low
    case medium
    case high
}
