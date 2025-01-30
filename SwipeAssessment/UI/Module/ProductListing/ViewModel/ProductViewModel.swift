//
//  ProductViewModel.swift
//  SwipeAssignment
//
//  Created by Satyam Singh on 29/01/25.
//


import SwiftUI
import Combine
import CoreData

class ProductListingViewModel: ObservableObject {
    
    @Published var filteredProducts: [ProductListingResponse] = []
    @Published var products: [ProductListingResponse] = []
    @Published var searchQuery: String = ""
    @Published var isLoading = false
    @Published var favorites: Set<UUID> = []
    @Published var productsLoaded: Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    private var searchCancellable: AnyCancellable?
    
    private let defaultImageURL = "https://via.placeholder.com/150"
    
    var managedObjectContext: NSManagedObjectContext!

        func fetchProductsFromCoreData() {
            let request = NSFetchRequest<ProductList>(entityName: "ProductList")
            do {
                let productEntities = try managedObjectContext.fetch(request)
                self.products = productEntities.map { $0.toProductListingResponse() }
                self.filterProducts()
                if products.isEmpty {
                    self.fetchProductsFromAPI()
                }
            } catch {
                print("Error fetching from Core Data: \(error)")
                self.fetchProductsFromAPI()
            }
        }

    func fetchProductsFromAPI() {
            self.isLoading = true
            UrlSessionManagers.shared.fetchProductListing { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let productListing):
                        self.products = productListing
                        self.filterProducts()
                        self.saveProductsToCoreData(productListing)
                    case .failure(let error):
                        print("❌ Error fetching products: \(error.localizedDescription)")
                    }
                    self.isLoading = false

                }
            }
        }
    // MARK: Managed Context
    private func saveProductsToCoreData(_ products: [ProductListingResponse]) {
            products.forEach { product in
                let productEntity = ProductList(context: managedObjectContext)
                productEntity.id = product.id
                productEntity.image = product.image
                productEntity.price = product.price ?? 0.0
                productEntity.productName = product.productName
                productEntity.productType = product.productType
                productEntity.tax = product.tax ?? 0.0
            }

            do {
                try managedObjectContext.save()
            } catch {
                print("Error saving to Core Data: \(error)")
            }
        }

    func toggleFavorite(product: ProductListingResponse) {
        guard let productId = product.id else { return }
        if self.favorites.contains(productId) {
            favorites.remove(productId)
        } else {
            self.favorites.insert(productId)
        }
        
        self.filterProducts()
    }
    
    func filterProducts() {
        let filtered = searchQuery.isEmpty ? products : products.filter { product in
            if let productName = product.productName {
                return productName.lowercased().contains(searchQuery.lowercased())
            }
            return false
        }
        
        // Sort: Favorited products should appear at the top
        filteredProducts = filtered.sorted { (lhs, rhs) in
            favorites.contains(lhs.id!) && !favorites.contains(rhs.id!)
        }
        self.isLoading = false
        self.productsLoaded = true
    }
}
extension ProductList {
    func toProductListingResponse() -> ProductListingResponse {
        return ProductListingResponse(
            id: self.id,
            image: self.image,
            price: self.price,
            productName: self.productName,
            productType: self.productType,
            tax: self.tax
        )
    }
}
