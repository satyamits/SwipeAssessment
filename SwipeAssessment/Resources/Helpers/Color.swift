//
//  Color.swift
//  SwipeAssignment
//
//  Created by Satyam Singh on 30/01/25.
//

import Foundation
import SwiftUI

extension Color {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> Color {
        return Color.init(red: red/255.0, green: green/255.0, blue: blue/255.0)
    }
    
    static var themeGreenMedium: Color {
        return Color.rgb(red: 0, green: 77, blue: 64)
    }
    
    static var themeColor: Color {
        return Color.rgb(red: 239, green: 239, blue: 239)
    }
    
    static var themeWhite: Color {
        return Color.rgb(red: 239, green: 239, blue: 239)
    }
}
