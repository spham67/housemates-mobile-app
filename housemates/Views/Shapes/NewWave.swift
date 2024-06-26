//
//  NewWave.swift
//  housemates
//
//  Created by Daniel Gunawan on 12/4/23.
// referenced from: https://www.youtube.com/watch?v=3ZHxF5Kwcqk
//

import SwiftUI

struct NewWave: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        
        path.addCurve(to: CGPoint(x: rect.minX, y: rect.maxY), control1: CGPoint(x: rect.maxX * 0.55, y: rect.maxY * 0.5), control2: CGPoint(x: rect.maxX * 0.45, y: rect.maxY * 1.5))
        
        path.closeSubpath()
        
        return path
    }
}

#Preview {
    NewWave()
        .stroke(Color.red, lineWidth: 5)
        .frame(height: 200)
}
