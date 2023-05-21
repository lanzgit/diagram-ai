//
//  ModalView.swift
//  DiagramAI
//
//  Created by Vinicius Vianna on 21/05/23.
//

import SwiftUI

struct ModalView: View {
    
    @Binding var isShowingImage: Bool
    @Binding var plantUMLImage: UIImage?
    @State private var curHeight: CGFloat = 400
    
    let minHeight: CGFloat = 400
    let maxHeight: CGFloat = 700
    
    var body: some View {
        ZStack(alignment: .top) {
            if isShowingImage {
                ZStack(alignment: .bottom) {
                    Color.black
                        .opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture {
                            isShowingImage = false
                        }
                    mainView
                        .transition(.move(edge: .bottom))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .ignoresSafeArea()
                .animation(.easeInOut)
            }
        }
    }
    
    var mainView: some View {
        VStack {
            ZStack {
                Capsule()
                    .frame(width: 40, height: 6)
                    .onTapGesture {
                        isShowingImage = false
                    }
            }
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            .background(.white.opacity(0.00001))
            .gesture(dragGesture)
            
            ZStack {
                VStack {
                    Text("Diagrama")
                        .font(.system(size: 30))
                        .bold()
                    if let plantUMLImage = plantUMLImage {
                        Image(uiImage: plantUMLImage)
                            .resizable()
                            .cornerRadius(16)
                        
                        let img = Image(uiImage: plantUMLImage)
                        ShareLink("Share", item: img, preview: SharePreview("photo", image: img))
                            .bold()
                            .padding()
                            .background(.black)
                            .foregroundColor(.white)
                            .cornerRadius(32)
                    }
                    Spacer()
                }
                .padding(.horizontal, 30)
            }
            .frame(maxHeight: .infinity)
            .padding(.bottom, 35)
        }
        .frame(height: curHeight)
        .frame(maxWidth: .infinity)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                Rectangle()
                    .frame(height: curHeight / 2)
            }
                .foregroundColor(.white)
        )
    }
    
    @State private var prevDrag = CGSize.zero
    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged { value in
                let dragAmount = value.translation.height - prevDrag.height
                if curHeight > maxHeight || curHeight < minHeight {
                    curHeight -= dragAmount / 6
                } else {
                    curHeight -= dragAmount
                }
                prevDrag = value.translation
            }
            .onEnded { value in
                prevDrag = .zero
            }
    }
}

struct ModalView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(vm: ContentViewModel(api: ChatGPTAPI(apiKey: Constants.openAIKey)))
    }
}
