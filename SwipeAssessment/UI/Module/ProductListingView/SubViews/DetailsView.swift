//
//  DetailsView.swift
//  SwipeAssessment
//
//  Created by Satyam Singh on 31/01/25.
//

import Foundation
import SwiftUI

struct DetailsView: View {
    @Binding var dismiss: Bool
    var product: ProductListingResponse
    @Binding var isFavorite: Bool
    let onFavoriteTapped: () -> Void
    
    
    var body: some View {
        
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea(.all)
            ProductCardView(product: product, isFavorite: $isFavorite, onFavoriteTapped: self.onFavoriteTapped)
        }
        .onTapGesture {
            dismiss = false
        }
    }
}
