//
//  Product.swift
//  SwipeAssignment
//
//  Created by Satyam Singh on 29/01/25.
//


import SwiftData
import Foundation

@Model
final class Product: Identifiable {
    var id: UUID
    var productId: UUID? 
    var image: String?
    var price: Double?
    var productName: String?
    var productType: String?
    var tax: Double?
    var isFavorite: Bool

    init(id: UUID = UUID(), productId: UUID? = nil, image: String? = nil, price: Double? = nil, productName: String? = nil, productType: String? = nil, tax: Double? = nil, isFavorite: Bool = false) {
        self.id = id
        self.productId = productId
        self.image = image
        self.price = price
        self.productName = productName
        self.productType = productType
        self.tax = tax
        self.isFavorite = isFavorite
    }
}
