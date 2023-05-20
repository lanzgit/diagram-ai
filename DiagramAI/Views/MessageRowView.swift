//
//  MessageRowView.swift
//  DiagramAI
//
//  Created by Vinicius Vianna on 07/05/23.
//

import SwiftUI

struct MessageRowView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    let message: MessageRow
    let retryCallback: (MessageRow) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            messageRow(text: message.sendText, image: message.sendImage, bgColor: colorScheme == .light ? .white : Color(red: 52/255, green: 53/255, blue: 65/255, opacity: 0.5))
            
            if let text = message.responseText {
                Divider()
                messageRow(text: text, image: message.responseImage, bgColor: colorScheme == .light ? .gray.opacity(0.1) : Color(red: 52/255, green: 53/255, blue: 65/255, opacity: 1), responseError: message.responseError)
                Divider()
            }
        }
    }
    
    func messageRow(text: String, image: String, bgColor: Color, responseError: String? = nil, showLoading: Bool = false) -> some View {
        
        HStack(alignment: .top, spacing: 24) {
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
            
            VStack(alignment: .leading) {
                if !text.isEmpty {
                    Text(text)
                        .multilineTextAlignment(.leading)
                        .textSelection(.enabled)
                }
                if let error = responseError {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.leading)
                    Button("Refazer a Pergunta") {
                        retryCallback(message)
                    }
                    .foregroundColor(.accentColor)
                    .padding(.top)
                    
                    if showLoading {
                        LoadingView()
                            .frame(width: 60, height: 30)
                    }
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(bgColor)
        .cornerRadius(12)
    }
}

struct MessageRowView_Previews: PreviewProvider {
    
    static let message = MessageRow(
        isInteractingWithChat: false, sendImage: "me",
        send: .rawText("Oi"),
        responseImage: "openai",
        response: .rawText("Oi, estou funcionando!"))
    
    static let message2 = MessageRow(
        isInteractingWithChat: false, sendImage: "me",
        send: .rawText("Como vai?"),
        responseImage: "openai",
        response: .rawText(""),
        responseError: "Chat não disponivel no momento")
    
    static var previews: some View {
        NavigationStack {
            ScrollView {
                MessageRowView(message: message, retryCallback: { messageRow in
                    
                })
                MessageRowView(message: message2, retryCallback: { messageRow in
                    
                })
            }
            .frame(width: 400)
            .previewLayout(.sizeThatFits)
        }
    }
}
