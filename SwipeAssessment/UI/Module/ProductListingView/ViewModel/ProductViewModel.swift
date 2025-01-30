//
//  ProductViewModel.swift
//  SwipeAssignment
//
//  Created by Satyam Singh on 29/01/25.
//


import SwiftUI
import Combine
import SwiftData

class ProductListingViewModel: ObservableObject {
    
    @Environment(\.modelContext) private var modelContext: ModelContext
    
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
                    self.isLoading = false // Set loading to false after API call (success or failure)

                }
            }
        }
    
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
                // Handle the error appropriately (e.g., show an alert to the user).
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

import SwiftUI
import CoreData
import Combine

//class ProductListingViewModel: ObservableObject {
//    
//    @Published var filteredProducts: [ProductList] = []
//    @Published var searchQuery: String = ""
//    @Published var isLoading = false
//    @Published var favorites: Set<UUID> = []
//    
//    private var cancellables = Set<AnyCancellable>()
//    private let context = CoreDataManager.shared.context
//    
//    func fetchProducts() {
//        self.isLoading = true
//        
//        // 1️⃣ Fetch from Core Data
//        let request: NSFetchRequest<ProductList> = ProductList.fetchRequest()
//        do {
//            let storedProducts = try context.fetch(request)
//            if !storedProducts.isEmpty {
//                self.filteredProducts = storedProducts
//                self.isLoading = false
//                return
//            }
//        } catch {
//            print("❌ Error fetching from Core Data: \(error)")
//        }
//        
//        // 2️⃣ Fetch from API if Core Data is empty
//        UrlSessionManagers.shared.fetchProductListing { result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let productListing):
//                    self.saveProductsToCoreData(products: productListing)
//                case .failure(let error):
//                    print("❌ API Fetch Error: \(error.localizedDescription)")
//                }
//                self.isLoading = false
//            }
//        }
//    }
//
//    private func saveProductsToCoreData(products: [ProductListingResponse]) {
//        for product in products {
//            let entity = ProductList(context: context)
//            entity.id = product.id ?? UUID()
//            entity.productName = product.productName
//            entity.productType = product.productType
//            entity.price = product.price ?? 0.0
//            entity.tax = product.tax ?? 0.0
//            entity.image = product.image
//            
//            print("✅ Saving Product: \(entity.productName ?? "Unknown")")
//        }
//
//        CoreDataManager.shared.saveContext()
//        
//        // 3️⃣ Fetch from Core Data after saving
//        let request: NSFetchRequest<ProductList> = ProductList.fetchRequest()
//        if let storedProducts = try? context.fetch(request) {
//            self.filteredProducts = storedProducts
//        }
//    }
//    
//    func filterProducts() {
//        let request: NSFetchRequest<ProductList> = ProductList.fetchRequest()
//        do {
//            let allProducts = try context.fetch(request)
//            let filtered = searchQuery.isEmpty ? allProducts : allProducts.filter { product in
//                product.productName?.lowercased().contains(searchQuery.lowercased()) ?? false
//            }
//            
//            // Sort: Favorited products should appear at the top
//            filteredProducts = filtered.sorted { favorites.contains($0.id!) && !favorites.contains($1.id!) }
//        } catch {
//            print("❌ Error filtering products: \(error)")
//        }
//    }
//}
