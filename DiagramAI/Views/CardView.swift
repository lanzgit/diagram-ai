//
//  CardView.swift
//  DiagramAI
//
//  Created by Vinicius Vianna on 25/05/23.
//

import SwiftUI

struct CardView: View {
    
    let card: Card
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 34, style: .continuous)
                .fill(card.color)
                .shadow(radius: 10)
            VStack {
                Text(card.title)
                    .foregroundColor(.white)
                    .font(.title)
                    .bold()
                    .lineLimit(2)
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .center)
                Spacer()
                Text(card.text)
                    .foregroundColor(.white)
                    .bold()
                    .font(.system(size: 20))
                    .padding()
                Image(card.image)
                    .resizable()
                    .frame(width: 80, height: 80)
                    .padding(.bottom, 50)
            }
        }
        .padding()
        .frame(width: 300, height: 400)
    }
}
    
struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card.tipos)
    }
}
    
