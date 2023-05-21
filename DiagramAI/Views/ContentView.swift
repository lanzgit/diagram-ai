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
    
    @State private var currentTab: Tab = .Home
    @State private var plantUMLCode: String = ""
    @State private var diagramImage: UIImage? = nil
    @State private var encodeUML = PlantUMLEncode()
    @State private var chatMessages: [ChatMessage] = ChatMessage.sampleMasseges
    @State private var messageText: String = ""
    @State private var diagramType: DiagramType = .Usecase
    @State private var plantumlCode: String = ""
    @State private var showTextField = false
    

        
    var body: some View {
        VStack {
            if let diagramImage = diagramImage {
                Image(uiImage: diagramImage)
                    .resizable()
                    .cornerRadius(16)
            }
            chatScrollView
        }
        .padding()
        .background(colorScheme == .light ? .white : Color(red: 52/255, green: 53/255, blue: 65/255, opacity: 0.5))
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
                Spacer()
            }
            .onChange(of: vm.messages.last?.responseText) { _ in
                scrollToBottom(proxy: proxy)
            }
        }
        .background(colorScheme == .light ? .white : Color(red: 52/255, green: 53/255, blue: 65/255, opacity: 0.5))
    }
    
    
    func bottomView(image: String, proxy: ScrollViewProxy) -> some View {
        VStack {
            Text("Escolha um tipo de diagrama")
                .font(.system(size: 20))
                .bold()
            HStack {
                ForEach(DiagramType.allCases, id: \.self) { diagramType in
                    Button(diagramType.rawValue) {
                        showTextField = true
                        print("Selected \(diagramType.rawValue)")
                        self.diagramType = diagramType
                        
                        Task { @MainActor in
                            isFieldFocussed = false
                            scrollToBottom(proxy: proxy)
                            await vm.sendBasePrompt(diagramType: diagramType.diagramName)
                        }
                    }
                    .padding()
                    .background(Color(.purple))
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    .bold()
                }
            }
            if showTextField {
                HStack(alignment: .top, spacing: 8) {
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
                                
                                //                      await vm.sendTapped()
                                let code = await vm.sendCode(text: vm.inputMessage)
                                generateDiagram(code: code ?? "algo aconteceu de errado")
                                vm.inputMessage = ""
                            }
                        } label: {
                            Image(systemName: "paperplane.circle.fill")
                                .rotationEffect(.degrees(45))
                                .font(.system(size: 50))
                                .foregroundColor(.purple)
                        }
                        .disabled(vm.inputMessage
                            .trimmingCharacters(in:
                                    .whitespacesAndNewlines).isEmpty)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
            }
        }
    }
    
    func messageView(message: ChatMessage) -> some View {
        HStack {
            if message.sender == .me { Spacer() }
            Text(message.content)
                .foregroundColor(message.sender == .me ? .white : .black)
                .padding()
                .background(message.sender == .me ? .blue : .gray.opacity(0.1))
                .cornerRadius(16)
            if message.sender == .gpt { Spacer() }
        }.padding()
    }
    
    private func scrollToBottom(proxy: ScrollViewProxy) {
        guard let id = vm.messages.last?.id else { return }
        proxy.scrollTo(id, anchor: .bottomTrailing)
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
