//
//  ProductListingResponse.swift
//  SwipeAssignment
//
//  Created by Satyam Singh on 29/01/25.
//

import Foundation


struct ProductListingResponse: Identifiable, Codable {
    
    var id: UUID? = UUID()
    var image: String?
    var price: Double?
    var productName, productType: String?
    var tax: Double?

    enum CodingKeys: String, CodingKey {
        case image, price
        case productName = "product_name"
        case productType = "product_type"
        case tax
    }
}

typealias ProductListing = [ProductListingResponse]
