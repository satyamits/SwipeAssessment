//
//  ProductCardView.swift
//  SwipeAssignment
//
//  Created by Satyam Singh on 29/01/25.
//


import SwiftUI

struct ProductCardView: View {
    
    @State var product: ProductListingResponse
    
    @Binding var isFavorite: Bool
    let onFavoriteTapped: () -> Void
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            HStack {
                AsyncImage(url: URL(string: product.image?.isEmpty == true ? "https://via.placeholder.com/150" : (product.image ?? "https://via.placeholder.com/150"))) { image in
                    image.resizable()
                } placeholder: {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 90, height: 90)
                        .background(Color.gray.opacity(0.3))
                }
                .frame(width: 90, height: 90)
                .cornerRadius(10)

                
                VStack(alignment: .leading, spacing: 4) {
                    Text(product.productName ?? "")
                        .font(.tertiary(.h18))
                        .foregroundStyle(Color.black)
                    
                    Text(product.productType ?? "")
                        .font(.tertiary(.c15))
                        .foregroundColor(.gray)
                    
                    Text("🛒 Tax: \(product.tax ?? 0.0, specifier: "%.2f")%")
                        .font(.tertiary(.c12))
                        .foregroundColor(.red)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("$\(product.price ?? 0.0, specifier: "%.2f")")
                        .font(.tertiary(.h20))
                        .foregroundStyle(Color.black)
                    
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 6)
                .stroke(Color.black, lineWidth: 1))
            .background(Color.white)
            Button {
                withAnimation {
                    self.onFavoriteTapped()
                }
            } label: {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(isFavorite ? .red : .gray)
                    .padding()
                    .padding(.trailing, -10)
                    .padding(.top, -10)
            }
            
        }
        .padding()
        
    }
}

