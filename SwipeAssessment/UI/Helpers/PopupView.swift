//
//  PopupView.swift
//  SwipeAssignment
//
//  Created by Satyam Singh on 30/01/25.
//

import SwiftUI

struct PopupView: View {
    
    @State var product: ProductListingResponse
    var dismiss: () -> Void
    
    var body: some View {
        
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea(.all)
            VStack(spacing: 20) {
                Text("Product added successfully 🎉!")
                    .font(.secondary(.c14))
                    .padding()
                    .background(Color.gray.opacity(0.9))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                HStack {
                    // Product Image
                    AsyncImage(url: URL(string: (product.image!.isEmpty ? "https://via.placeholder.com/150" : product.image)!)) { image in
                        image.resizable()
                    } placeholder: {
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80)
                            .background(Color.gray.opacity(0.3))
                    }
                    .frame(width: 80, height: 80)
                    .cornerRadius(10)

                    // Product Details
                    VStack(alignment: .leading) {
                        Text(product.productName ?? "")
                            .font(.headline)
                        Text(product.productType ?? "")
                            .font(.secondary(.c20))
                            .foregroundColor(.gray)
                        HStack {
                            Text("💰 \(product.price ?? 0.0, specifier: "%.2f")")
                            Spacer()
                            Text("🛒 Tax: \(product.tax ?? 0.0, specifier: "%.2f")%")
                                .foregroundColor(.red)
                        }
                        .font(.caption)
                    }
                    .padding(.leading, 5)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 3)
                .padding(.horizontal)

                
                Button {
                    self.dismiss()
                } label: {
                    Text("Okay")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.themeGreenMedium)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                }
                .padding(.top, 10)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 10)
            .padding(.horizontal, 12)
        }
        .onTapGesture {
            self.dismiss()
        }
    }
}

#Preview {
    PopupView(product: ProductListingResponse(image: "", price: 200.0, productName: "dfsdfsdfsd", productType: "3423423", tax: 2.00), dismiss: {})
}
