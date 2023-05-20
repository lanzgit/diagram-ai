//
//  ChatMessage.swift
//  DiagramAI
//
//  Created by Vinicius Vianna on 08/05/23.
//

import Foundation

struct ChatMessage {
    let id: String
    let content: String
    let dateCreated: Date
    let sender: MessageSender
    
}

enum MessageSender {
    case me
    case gpt
}

extension ChatMessage {
    static let sampleMasseges = [
        ChatMessage(id: UUID().uuidString, content: "Mensagem do Usuario", dateCreated: Date(), sender: .me),
        ChatMessage(id: UUID().uuidString, content: "Mensagem do ChatGPT", dateCreated: Date(), sender: .gpt),
        ChatMessage(id: UUID().uuidString, content: "Mensagem do Usuario", dateCreated: Date(), sender: .me),
        ChatMessage(id: UUID().uuidString, content: "Mensagem do ChatGPT", dateCreated: Date(), sender: .gpt),
    ]
}
