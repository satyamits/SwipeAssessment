//
//  AddProductButton.swift
//  SwipeAssignment
//
//  Created by Satyam Singh on 30/01/25.
//
import SwiftUI

struct AddProductButton: View {
    
    var size: CGFloat = 75
    @Binding var showAddProductView: Bool
    
    var body: some View {
        Button {
            self.showAddProductView = true
        } label: {
            HStack {
                Text("Add Product")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.black)
                Image(systemName: "plus")
                    .foregroundStyle(.black)
            }
            .padding()
            .frame(width: size * 2, height: 40)
            .background(
                ZStack {
                    Color.white
                    Rectangle()
                        .stroke(Color.white.opacity(0.8), lineWidth: 4)
                        .offset(x: -2, y: -2)
                    Rectangle()
                        .stroke(Color.gray.opacity(0.6), lineWidth: 4)
                        .offset(x: 2, y: 2)
                    Rectangle()
                        .stroke(Color.black, lineWidth: 2)
                }
            )
            .cornerRadius(4)
            .padding(.trailing, 12)
        }
        
    }
}
