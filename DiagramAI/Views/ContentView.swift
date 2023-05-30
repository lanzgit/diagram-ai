//
//  ContentView.swift
//  DiagramAI
//
//  Created by Vinicius Vianna on 06/05/23.
//

import SwiftUI
import Foundation
import AVKit

struct ContentView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @FocusState var isFieldFocussed: Bool
    @ObservedObject var vm: ContentViewModel
    
    @State private var cards: Array<Card> = [Card.openaiCard, Card.plantumlCard, Card.tipos]
    @State private var isShowingCards = true
    @State private var plantUMLCode: String = ""
    @State private var diagramImage: UIImage? = nil
    @State private var encodeUML = PlantUMLEncode()
    @State private var messageText: String = ""
    @State private var plantumlCode: String = ""
    @State private var showTextField = false
    @State private var isActive = false
    @State private var isShowingImage = false
    
    var body: some View {
        ZStack(alignment: .top) {
            if let diagramImage = diagramImage {
                Image(uiImage: diagramImage)
                    .resizable()
                    .cornerRadius(16)
            }
            if isShowingCards {
                caroucel()
                    .zIndex(1)
            }
            chatScrollView
            ModalView(isShowingImage: $isShowingImage, plantUMLImage: $diagramImage)
                .ignoresSafeArea()
        }
        .navigationTitle("diagramAI")
        .environment(\.colorScheme, .dark)
    }
    
    
    var chatScrollView: some View {
        ScrollViewReader { proxy in
            VStack(spacing: 0) {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(vm.messages) { message in
                            MessageRowView(message: message) { message in
                                Task { @MainActor in
                                    await vm.retry(message: message)
                                }
                            }
                        }
                    }
                    .onTapGesture {
                        isFieldFocussed = false
                    }
                }
                Divider()
                bottomView(image: "me", proxy: proxy)
                    .background(showTextField ? Color("menuBack").ignoresSafeArea() : nil)
            }
            .background(Color("myBackground"))
            .onChange(of: vm.messages.last?.responseText) { _ in
                scrollToBottom(proxy: proxy)
            }
        }
    }
    
    
    func bottomView(image: String, proxy: ScrollViewProxy) -> some View {
        ZStack {
            ZStack {
                MenuItem(icon: "figure.arms.open", background: Color("myOrange"), foreground: .white, order: 1, isActive: isActive, name: "UseCase", action: {
                    showTextField = true
                    isActive = !isActive
                    Task { @MainActor in
                        isFieldFocussed = false
                        isShowingCards = false
                        scrollToBottom(proxy: proxy)
                        await vm.sendBasePrompt(diagramType: "Use Case Diagram")
                    }
                })
                .opacity(isActive ? 1 : 0)
                MenuItem(icon: "flowchart.fill", background: Color("myPink"), foreground: .white, order: 3, isActive: isActive, name: "Class", action: {
                    showTextField = true
                    isActive = !isActive
                    Task { @MainActor in
                        isFieldFocussed = false
                        isShowingCards = false
                        scrollToBottom(proxy: proxy)
                        await vm.sendBasePrompt(diagramType: "Class Diagram")
                    }
                })
                .opacity(isActive ? 1 : 0)
                MenuItem(icon: "figure.walk", background: Color("anotherGreen"), foreground: .white, order: 5, isActive: isActive, name: "Sequence", action: {
                    showTextField = true
                    isActive = !isActive
                    Task { @MainActor in
                        isFieldFocussed = false
                        isShowingCards = false
                        scrollToBottom(proxy: proxy)
                        await vm.sendBasePrompt(diagramType: "Sequence Diagram")
                    }
                })
                .opacity(isActive ? 1 : 0)
                MenuItem(icon: "plus", background: Color("myPurple"), foreground: Color.white, size: 24, weight: .bold, name: "", action: {
                    isActive = !isActive
                })
                .bold()
                .rotationEffect(isActive ? .degrees(-225) : .zero)
                .animation(.spring())
                .offset(y: -40)
            }
//            .padding(.bottom, 40)
            
            if showTextField {
                HStack(alignment: .bottom, spacing: 8) {
                    if image.hasPrefix("http"), let url = URL(string: image) {
                        AsyncImage(url: url) { image in
                            image.resizable().frame(width: 25, height: 25)
                        } placeholder: {
                            ProgressView()
                        }
                    } else {
                        Image(image)
                            .resizable()
                            .frame(width: 50, height: 50)
                            .cornerRadius(100)
                    }
                    TextField("Envie uma mensagem...", text: $vm.inputMessage, axis: .vertical)
                        .padding()
                        .accentColor(Color("myPurple"))
                        .foregroundColor(.white)
                        .background(.gray.opacity(0.2))
                        .cornerRadius(16)
                        .focused($isFieldFocussed)
                        .disabled(vm.isInteractiveWithGPT)
                    
                    if vm.isInteractiveWithGPT {
                        LoadingView().frame(width: 60, height: 30)
                    } else {
                        Button {
                            Task { @MainActor in
                                isFieldFocussed = false
                                scrollToBottom(proxy: proxy)
                                
                                let code = await vm.sendCode(text: vm.inputMessage)
                                generateDiagram(code: code ?? "algo aconteceu de errado")
                                vm.inputMessage = ""
                            }
                        } label: {
                            Image(systemName: "paperplane.circle.fill")
                                .rotationEffect(.degrees(45))
                                .font(.system(size: 50))
                                .foregroundColor(Color("myPurple"))
                        }
                        .disabled(vm.inputMessage
                            .trimmingCharacters(in:
                                    .whitespacesAndNewlines).isEmpty)
                    }
                }
                .padding()
            }
        }
    }
    
    private func scrollToBottom(proxy: ScrollViewProxy) {
        guard let id = vm.messages.last?.id else { return }
        proxy.scrollTo(id, anchor: .bottomTrailing)
    }
    
    private func caroucel() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(0..<cards.count, id: \.self) { card in
                    GeometryReader { geometry in
                        CardView(card: cards[card])
                            .rotation3DEffect(Angle(degrees: (Double(geometry.frame(in: .global).minX) - 40) / -10), axis: (x: 0, y: 10.0, z: 0))
                    }
                    .frame(width: 246)
                }
            }
            .padding(20)
        }
        .frame(width: UIScreen.main.bounds.width, height: 420)
    }
    
    func generateDiagram(code: String) {
        let newEncodedUML = PlantUMLEncode().compressAndEncode(code)
        let requestURL = "http://www.plantuml.com/plantuml/png/\(newEncodedUML)"
       
        guard let url = URL(string: requestURL) else {
           print("Invalid URL")
           return
        }
       
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
               DispatchQueue.main.async {
                   self.diagramImage = image
                   isShowingImage = true
               }
           } else {
               print("Error generating diagram: \(error?.localizedDescription ?? "Unknown error")")
           }
        }.resume()
       }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ContentView(vm: ContentViewModel(api: ChatGPTAPI(apiKey: Constants.openAIKey)))
        }
    }
}
