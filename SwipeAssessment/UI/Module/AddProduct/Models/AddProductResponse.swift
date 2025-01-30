//
//  AddProductResponse.swift
//  SwipeAssignment
//
//  Created by Satyam Singh on 30/01/25.
//


struct AddProductResponse: Codable {
    var message: String?
    var productDetails: ProductListingResponse?
    var productID: Int?
    var success: Bool?

    enum CodingKeys: String, CodingKey {
        case message
        case productDetails = "product_details"
        case productID = "product_id"
        case success
    }
}
