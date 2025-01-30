//
//  UserImageView.swift
//  SwipeAssignment
//
//  Created by Satyam Singh on 30/01/25.
//
import SwiftUI


//struct AddProductButton: View {
//    
//    var lineWidth: CGFloat
//    var borderColor: Color
//    var size: CGFloat
//    @Binding var showAddProductView: Bool
//    
//    var body: some View {
//        Button {
//            self.showAddProductView = true
//        } label: {
//            HStack {
//                Text("Add Product")
//                    .font(.tertiary(.c12))
//                    .foregroundStyle(Color.black)
//                Image(systemName: "plus")
//                    
//                    
//                    .padding(.trailing, 12)
//                    .foregroundStyle(Color.black)
//            }
//            
//            .padding()
//        }
//    }
//}

//struct AddProductButton: View {
//    
//    var lineWidth: CGFloat = 3
//    var borderColor: Color = .black
//    var size: CGFloat = 60
//    @Binding var showAddProductView: Bool
//    
//    var body: some View {
//        Button {
//            self.showAddProductView = true
//        } label: {
//            HStack {
//                Text("Add Product")
//                    .font(.system(size: 14, weight: .bold))
//                    .foregroundStyle(.black)
//                Image(systemName: "plus")
//                    .foregroundStyle(.black)
//            }
//            .padding()
//            .frame(width: size * 2, height: size)
//            .background(
//                ZStack {
//                    Color.white
//                    RoundedRectangle(cornerRadius: 8)
//                        .stroke(borderColor, lineWidth: lineWidth)
//                        .shadow(color: .gray.opacity(0.5), radius: 5, x: 3, y: 3) // 3D shadow effect
//                        .shadow(color: .white, radius: 5, x: -3, y: -3) // Light reflection
//                }
//            )
//            .cornerRadius(8)
//            .padding(.trailing, 12)
//        }
//         // Removes default button styling
//    }
//}


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
