//
//  SplashView.swift
//  DiagramAI
//
//  Created by Vinicius Vianna on 10/05/23.
//

import SwiftUI
import UIColorHexSwift

struct SplashView: View {
    
    @State private var isActive = false
    @State private var size = 0.7
    @State private var opacity = 0.5
    @ObservedObject var vm: ContentViewModel
    
    var body: some View {
        
        if isActive {
            ContentView(vm: ContentViewModel(api: ChatGPTAPI(apiKey: Constants.openAIKey)))
        } else {
            ZStack {
                HStack {
                    Image("logo")
                    Text("diagram.ai")
                        .foregroundColor(.white)
                        .font(Font.custom("Menlo", size: 30))
                        .bold()
                    
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.2)) {
                        self.size = 1.0
                        self.opacity = 1.0
                    }
                }
                VStack {
                    Spacer()
                    Text("powered by")
                        .foregroundColor(.white)
                        .font(Font.custom("Menlo", size: 15))
                        .bold()
                    HStack {
                        Image("openai")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .cornerRadius(80)
                        
                        Image("plantumlLogo")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .cornerRadius(80)
                    }
                }
                .padding()
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(RadialGradient(gradient: Gradient(colors: [.black, .black.opacity(0.8)]), center: .center, startRadius: 2, endRadius: 650)
                    .ignoresSafeArea())
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView(vm: ContentViewModel(api: ChatGPTAPI(apiKey: Constants.openAIKey)))
    }
}
