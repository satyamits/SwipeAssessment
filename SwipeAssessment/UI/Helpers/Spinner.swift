//
//  Spinner.swift
//  SwipeAssessment
//
//  Created by Satyam Singh on 30/01/25.
//

import Foundation
import SwiftUI

struct Spinner: View {
    @State private var rotationAngle = 0.0
    private let ringSize: CGFloat = 80

    var colors: [Color] = [Color.red, Color.red.opacity(0.3)]

    var body: some View {
        ZStack {
            Rectangle()
                .fill(.gray.opacity(0.7))
                .ignoresSafeArea()
            
            ZStack {
                Circle()
                   .stroke(
                       AngularGradient(
                           gradient: Gradient(colors: colors),
                           center: .center,
                           startAngle: .degrees(0),
                           endAngle: .degrees(360)
                       ),
                       style: StrokeStyle(lineWidth: 16, lineCap: .round)
                       
                   )
                   .frame(width: ringSize, height: ringSize)

                Circle()
                    .frame(width: 16, height: 16)
                    .foregroundColor(Color.red)
                    .offset(x: ringSize/2)

            }
            .rotationEffect(.degrees(rotationAngle))
            .padding(.horizontal, 80)
            .padding(.vertical, 50)
            .background(RoundedRectangle(cornerRadius: 16).fill(Color.white))
            .onAppear {
                withAnimation(.linear(duration: 1.5)
                            .repeatForever(autoreverses: false)) {
                        rotationAngle = 360.0
                    }
            }
            .onDisappear{
                rotationAngle = 0.0
            }
        }

        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}
