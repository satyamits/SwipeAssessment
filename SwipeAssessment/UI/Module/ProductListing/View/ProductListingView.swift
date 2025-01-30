//
//  ProductListingView.swift
//  SwipeAssignment
//
//  Created by Satyam Singh on 29/01/25.
//

import Foundation
import SwiftUI

struct ProductListView: View {
    
    @Environment(\.managedObjectContext) private var managedObjectContext
    @StateObject private var viewModel = ProductListingViewModel()
    @State var showAddProductView: Bool = false
    @State var showAddProductSucessView: Bool = false
    @State var popupDetails = ProductListingResponse()
    @State var showDetailsView: Bool = false

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack {
                        Text("Products")
                            .font(.tertiary(.h28))
                            .foregroundStyle(Color.black)
                            .padding(.leading, 12)
                        Spacer()
                        AddProductButton(showAddProductView: self.$showAddProductView)
                    }
                    // Search Bar
                    TextField("Search products...", text: self.$viewModel.searchQuery)
                        .padding(12)
                        .background(
                            ZStack {
                                Color.white
                                Rectangle()
                                    .stroke(Color.white.opacity(0.8), lineWidth: 3)
                                    .offset(x: -2, y: -2)
                                Rectangle()
                                    .stroke(Color.gray.opacity(0.6), lineWidth: 3)
                                    .offset(x: 2, y: 2)
                                Rectangle()
                                    .stroke(Color.black, lineWidth: 2)
                            }
                        )
                        .frame(height: 40)
                        .padding()
                        .onChange(of: self.viewModel.searchQuery) {
                            withAnimation {
                                self.viewModel.filterProducts()
                            }
                        }
                    if self.viewModel.isLoading {
                        Spinner()
                    } else {
                        ScrollView {
                            LazyVStack {
                                ForEach(viewModel.filteredProducts) { product in
                                    ProductCardView(
                                        product: product,
                                        isFavorite: Binding(
                                            get: { viewModel.favorites.contains(product.id!) },
                                            set: { isFavorite in
                                                viewModel.toggleFavorite(product: product)
                                            }
                                        )) {
                                            viewModel.toggleFavorite(product: product)
                                        }
                                        .onTapGesture {
                                            withAnimation {
                                                self.showDetailsView = true
                                                self.popupDetails = product
                                            }
                                        }
                                }
                            }
                        }
                    }

                    
                }
                .background(Color.themeColor)
//                VStack {
//                    Spacer()
//                    Button {
//                        withAnimation(.linear(duration: 2)) {
//                            self.showAddProductView = true
//                        }
//                    } label: {
//                        Text("Add New Product")
//                            .font(.secondary(.h22))
//                            .frame(maxWidth: .infinity)
//                            .padding()
//                            .background(Color.themeGreenMedium)
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
//                            .padding()
//                    }
//                }
                if self.showAddProductSucessView {
                    PopupView(product: self.popupDetails) {
                        withAnimation {
                            self.showAddProductSucessView = false
                        }
                    }
                }
                
                if self.showDetailsView {
                    DetailsView(dismiss: self.$showDetailsView,
                                product: self.popupDetails,
                                isFavorite: Binding(
                        get: { viewModel.favorites.contains(self.popupDetails.id!) },
                        set: { isFavorite in
                            viewModel.toggleFavorite(product: self.popupDetails)
                        }
                    )) {
                        viewModel.toggleFavorite(product: self.popupDetails)
                    }
                }
            }
        
            .onAppear {
                viewModel.managedObjectContext = managedObjectContext
                viewModel.fetchProductsFromCoreData()
                viewModel.fetchProductsFromAPI()
            }
            .background(Color.themeColor)
        }
        .fullScreenCover(isPresented: self.$showAddProductView) {
            AddProductView(isSuccess: self.$showAddProductView) { response in
                withAnimation {
                    self.popupDetails = response
                    self.showAddProductSucessView = true
                }
            }
            .background(Color.themeColor.ignoresSafeArea(.all))
        }
        
    }
}

#Preview {
    ProductListView()
}
