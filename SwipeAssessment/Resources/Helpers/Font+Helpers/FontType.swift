//
//  FontType.swift
//  SwipeAssignment
//
//  Created by Satyam Singh on 29/01/25.
//


import Foundation
import SwiftUI

protocol FontProtocol {
    func font(forLevel level: FontType.FontLevel) -> UIFont
    var size: CGFloat { get }
}

enum FontType: FontProtocol {
    
    case h16
    case h17
    case h18
    case h20
    case h22
    case h24
    case h28
    case h32
    
    case s12
    case s14
    case s15
    case s16
    case s17
    case s18
    case s24
    
    case c12
    case c14
    case c15
    case c17
    case c18
    case c20
    case c24
    
    case p12
    case p13
    case p14
    case p15
    case p16
    case p18
    
    var size: CGFloat {
        switch self {
        case .s12, .c12, .p12:
            return 12
        case .p13:
            return 13
        case .s14, .c14, .p14:
            return 14
        case .s15, .c15, .p15:
            return 15
        case .h16, .s16, .p16:
            return 16
        case .c17, .s17, .h17:
            return 17
        case .h18, .s18, .c18, .p18:
            return 18
        case .h20, .c20:
            return 20
        case .h22:
            return 22
        case .h24, .s24, .c24:
            return 24
        case .h28:
            return 28
        case .h32:
            return 32
        }
    }
    
    func font(forLevel level: FontLevel) -> UIFont {
        switch level {
        case .primary:
            switch self {
            case .h16, .h17, .h18, .h20, .h22, .h24, .h28, .h32:
                return FontFamily.Lato.bold.font(size: self.size)
            case .s12, .s14, .s15, .s16, .s17, .s18, .s24:
                return FontFamily.Lato.semibold.font(size: self.size)
            case .c12, .c14, .c15, .c17, .c18, .c20, .c24:
                return FontFamily.Lato.medium.font(size: self.size)
            case .p12, .p13, .p14, .p15, .p16, .p18:
                return FontFamily.Lato.regular.font(size: self.size)
            }
        case.secondary:
            switch self {
            case .h16, .h17, .h18, .h20, .h22, .h24, .h28, .h32:
                return FontFamily.PlayfairDisplay.bold.font(size: self.size)
            case .s12, .s14, .s15, .s16, .s17, .s18, .s24:
                return FontFamily.PlayfairDisplay.semiBold.font(size: self.size)
            case .c12, .c14, .c15, .c17, .c18, .c20, .c24:
                return FontFamily.PlayfairDisplay.medium.font(size: self.size)
            case .p12, .p13, .p14, .p15, .p16, .p18:
                return FontFamily.PlayfairDisplay.regular.font(size: self.size)
            }
        case .tertiary:
            switch self {
            case .h16, .h17, .h18, .h20, .h22, .h24, .h28, .h32:
                return FontFamily.Poppins.bold.font(size: self.size)
            case .s12, .s14, .s15, .s16, .s17, .s18, .s24:
                return FontFamily.Poppins.semiBold.font(size: self.size)
            case .c12, .c14, .c15, .c17, .c18, .c20, .c24:
                return FontFamily.Poppins.medium.font(size: self.size)
            case .p12, .p13, .p14, .p15, .p16, .p18:
                return FontFamily.Poppins.regular.font(size: self.size)
            }
        }
    }
    
    enum FontLevel {
        case primary
        case secondary
        case tertiary
    }
}
