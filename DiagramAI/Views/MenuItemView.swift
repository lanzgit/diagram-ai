//
//  MenuItemView.swift
//  DiagramAI
//
//  Created by Vinicius Vianna on 20/05/23.
//

import SwiftUI

struct MenuItem: View {
    let positions:[[CGFloat]] = [[0,0], [-110, -50], [-62, -90], [0, -110], [62, -90], [110, -50]]
    let icon: String
    var background: Color = Color.white
    var foreground: Color = Color.blue
    var size: CGFloat = 22
    var weight: Font.Weight = .regular
    var order: Int = 0
    var isActive: Bool = true
    var name: String
    var action: (() -> Void)?
    
    var body: some View {
        VStack {
            Button(action: {
                action?()
            }) {
                Image(systemName: icon)
                    .font(Font.system(size: size, weight: weight))
                    .frame(width: 56, height: 56)
                    .background(background)
                    .foregroundColor(foreground)
                    .cornerRadius(44)
            }
            .rotationEffect(isActive ? .degrees(1080) : .zero)
            .animation(.spring(response: 0.4, dampingFraction: 0.75))
            .offset(x: isActive ? positions[order][0] : 0, y: isActive ? positions[order][1] : 0)
           Text(name)
                .opacity(isActive ? 1 : 0)
                .foregroundColor(.black)
                .bold()
                .rotationEffect(isActive ? .degrees(1080) : .zero)
                .animation(.spring(response: 0.4, dampingFraction: 0.75))
                .offset(x: isActive ? positions[order][0] : 0, y: isActive ? positions[order][1] : 0)
        }
    }
}

struct MenuItemView: View {
    @State private var isActive: Bool = true
    
    var body: some View {
        ZStack {
            Color(.white)
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            Color(.white)
                .opacity(isActive ? 0.5 : 0)
                .animation(.easeOut(duration: 0.2))
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            VStack {
                Spacer()
                ZStack {
                    
                    MenuItem(icon: "figure.arms.open", background: .orange, foreground: .white, order: 1, isActive: isActive, name: "UseCase", action: {
                        
                    })
                        .opacity(isActive ? 1 : 0)
                    MenuItem(icon: "flowchart.fill", background: .cyan, foreground: .white, order: 3, isActive: isActive, name: "Class", action: {
                        
                    })
                        .opacity(isActive ? 1 : 0)
                    MenuItem(icon: "figure.walk", background: .indigo, foreground: .white, order: 5, isActive: isActive, name: "Sequence", action: {
                        
                    })
                        .opacity(isActive ? 1 : 0)
                    MenuItem(icon: "plus", background: Color.purple, foreground: Color.white, size: 24, weight: .bold, name: "", action: {
                        isActive = !isActive
                    })
                        .bold()
                        .rotationEffect(isActive ? .degrees(-225) : .zero)
                        .animation(.spring())
                }
            }.padding()
        }
    }
}


struct MenuItemView_Previews: PreviewProvider {
    static var previews: some View {
        MenuItemView()
    }
}
