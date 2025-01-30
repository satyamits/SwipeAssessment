//
//  AddProductViewModel.swift
//  SwipeAssignment
//
//  Created by Satyam Singh on 30/01/25.
//


import SwiftUI
import Combine

class AddProductViewModel: ObservableObject {
    // Published properties for binding with the View
    @Published var productName: String = ""
    @Published var selectedProductType: String = ""
    @Published var sellingPrice: String = ""
    @Published var taxRate: String = ""
    @Published var selectedImageData: Data? = nil
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var isSuccess: Bool = false
    @Published var addResponse: ProductListingResponse?
    @Published var showLoader: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    var productTypes: [String] = ["Electronics", "Clothing", "Furniture", "Books", "Others"]
    
    // Validate input fields
    func validateFields() -> Bool {
        if self.productName.isEmpty {
            self.alertMessage = "Product name cannot be empty."
            self.showAlert = true
            return false
        }
        
        if self.selectedProductType.isEmpty {
            self.alertMessage = "Please select a product type."
            self.showAlert = true
            return false
        }
        
        if !self.isValidDecimal(self.sellingPrice) {
            self.alertMessage = "Invalid selling price. Please enter a valid number."
            self.showAlert = true
            return false
        }
        
        if !self.isValidDecimal(self.taxRate) {
            self.alertMessage = "Invalid tax rate. Please enter a valid number."
            self.showAlert = true
            return false
        }
        
        return true
    }
    
    // Check if a string is a valid decimal number
    func isValidDecimal(_ value: String) -> Bool {
        let decimalRegex = "^[0-9]*\\.?[0-9]+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", decimalRegex)
        return predicate.evaluate(with: value)
    }
    
    // Submit the product to the API
    func submitProduct() {
        self.showLoader = true
        guard self.validateFields() else {
            self.showLoader = false
            return
        }
        
        let product = AddProduct(name: self.productName,
                                 type: self.selectedProductType,
                                 price: self.sellingPrice,
                                 tax: self.taxRate,
                                 imageData: self.selectedImageData)
        
        UrlSessionManagers.shared.submitProduct(with: product) { result in
            switch result {
                case .success(let response):
                print("Successfully submitted product: \(response)")
                self.alertMessage = response.message ?? ""
                self.addResponse = response.productDetails
                self.isSuccess = true
                self.showLoader = false
            case .failure(let error):
                
                print("Failed to submit product: \(error)")
                self.alertMessage = error.localizedDescription
                self.showAlert = true
                self.showLoader = false
            }
        }
    }
}
