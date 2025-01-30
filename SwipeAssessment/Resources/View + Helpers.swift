//
//  View + Helpers.swift
//  SwipeAssignment
//
//  Created by Satyam Singh on 30/01/25.
//

import Foundation

import Foundation
import SwiftUI

extension View {
 
    func shadowOverlay(xOffset: CGFloat, yOffset: CGFloat, radius: CGFloat, color: Color) -> some View {
            self
                .shadow(color: color, radius: radius, x: xOffset, y: yOffset)
        }
    
}
