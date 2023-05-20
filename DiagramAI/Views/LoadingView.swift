//
//  LoadingView.swift
//  DiagramAI
//
//  Created by Vinicius Vianna on 08/05/23.
//

import SwiftUI

struct LoadingView: View {
    
    @State private var alphaCircle = false
    @State private var betaCircle = false
    @State private var charlieCircle = false
    
    var body: some View {
        HStack {
            Circle().opacity(alphaCircle ? 1 : 0)
            Circle().opacity(betaCircle ? 1 : 0)
            Circle().opacity(charlieCircle ? 1 : 0)
        }
        .foregroundColor(.gray.opacity(0.5))
        .onAppear { performAnimation() }
    }
    
    func performAnimation() {
        let animation = Animation.easeInOut(duration: 0.4)
        withAnimation(animation) {
            self.alphaCircle = true
            self.charlieCircle = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(animation) {
                self.betaCircle = true
                self.alphaCircle = false
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation(animation) {
                self.betaCircle = false
                self.charlieCircle = true
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            self.performAnimation()
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
