//
//  AppFont.swift
//  SwipeAssignment
//
//  Created by Satyam Singh on 29/01/25.
//


import UIKit
import SwiftUI

struct AppFont {
    
    static func primary(_ fontType: FontType) -> UIFont {
        return fontType.font(forLevel: .primary)
    }
    
    static func secondary(_ fontType: FontType) -> UIFont {
        return fontType.font(forLevel: .secondary)
    }
    
    static func tertiary(_ fontType: FontType) -> UIFont {
        return fontType.font(forLevel: .tertiary)
    }
    
}

extension SwiftUI.Font {
    static func primary(_ fontType: FontType) -> SwiftUI.Font {
        return SwiftUI.Font(fontType.font(forLevel: .primary))
    }
    
    static func secondary(_ fontType: FontType) -> SwiftUI.Font {
        return SwiftUI.Font(fontType.font(forLevel: .secondary))
    }
    
    static func tertiary(_ fontType: FontType) -> SwiftUI.Font {
        return SwiftUI.Font(fontType.font(forLevel: .tertiary))
    }
}
