//
//  MenuItem.swift
//  DiagramAI
//
//  Created by Vinicius Vianna on 20/05/23.
//

import Foundation

struct MenuItem: View {
    let positions:[[CGFloat]] = [[0,0], [-110, -50], [-62, -90], [0, -110], [62, -90], [110, -50]]
    let icon: String
    var background: Color = Color.white
    var foreground: Color = Color.blue
    var size: CGFloat = 20
    var weight: Font.Weight = .regular
    var order: Int = 0
    var isActive: Bool = true
    var body: some View {
        Image(systemName: icon)
            .font(Font.system(size: size, weight: weight))
            .frame(width: 40, height: 40)
            .background(background)
            .foregroundColor(foreground)
            .cornerRadius(44)
            .rotationEffect(isActive ? .degrees(1080) : .zero)
            .animation(.spring(response: 0.4, dampingFraction: 0.75))
            .offset(x: isActive ? positions[order][0] : 0, y: isActive ? positions[order][1] : 0)
        
    }
}
