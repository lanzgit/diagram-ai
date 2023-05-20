//
//  ContentViewModel.swift
//  DiagramAI
//
//  Created by Vinicius Vianna on 07/05/23.
//

import SwiftUI
import ChatGPTSwift
import Foundation

class ContentViewModel: ObservableObject {
    
    @Published var isInteractiveWithGPT = false
    @Published var messages: [MessageRow] = []
    @Published var inputMessage: String = ""
    @Published var plantUMLCode: String? = ""
    
    private let api: ChatGPTAPI
    
    init(api: ChatGPTAPI) {
        self.api = api
    }
    
    @MainActor
    func sendTapped() async {
        let text = inputMessage
        inputMessage = ""
        await send(text: text)
//        await sendCode(text: text)
    }
    
    //TODO: aprimorar
    @MainActor
    func sendBasePrompt(diagramType: String) async {
        let baseText = "As a developer, I would like you to produce markups using PlantUML to generate diagrams on http://www.plantuml.com. Please ensure that there is adequate spacing in your diagrams. Please wait for my \(diagramType) descriptions before responding. Response with code, nothing else"
        await send(text: baseText)
    }
    
    @MainActor
    func retry(message: MessageRow) async {
        guard let index = messages.firstIndex(where: { $0.id == message.id }) else {
            return
        }
        self.messages.remove(at: index)
        await send(text: message.sendText)
    }
    
    @MainActor
    private func send(text: String) async {
        isInteractiveWithGPT = true
        var streamText = ""
        var messageRow = MessageRow(
            isInteractingWithChat: true,
            sendImage: "me",
            send: .rawText(text),
            responseImage: "openai",
            response: .rawText(streamText),
            codeBlock: "",
            responseError: nil)
        
        self.messages.append(messageRow)
        do {
            let stream = try await api.sendMessageStream(text: text)
            for try await text in stream {
                streamText += text
                messageRow.response = .rawText(streamText.trimmingCharacters(in: .whitespacesAndNewlines))
                
                messageRow.codeBlock = extractCodeBlock(response: messageRow.response!.text)
                
                self.messages[self.messages.count - 1] = messageRow
            }
        } catch {
            messageRow.responseError = error.localizedDescription
        }
        
        messageRow.isInteractingWithChat = false
        self.messages[self.messages.count - 1] = messageRow
        isInteractiveWithGPT = false
    }
    
    @MainActor
    func sendCode(text: String) async -> String? {
        isInteractiveWithGPT = true
        var streamText = ""
        var messageRow = MessageRow(
            isInteractingWithChat: true,
            sendImage: "me",
            send: .rawText(text),
            responseImage: "openai",
            response: .rawText(streamText),
            codeBlock: "",
            responseError: nil)
        
        do {
            let stream = try await api.sendMessageStream(text: text)
            for try await text in stream {
                streamText += text
                messageRow.response = .rawText(streamText.trimmingCharacters(in: .whitespacesAndNewlines))
                
                if let responseText = messageRow.response?.text {
                    messageRow.codeBlock = extractCodeBlock(response: responseText)
                }
            }
        } catch {
            messageRow.responseError = error.localizedDescription
        }
        messageRow.isInteractingWithChat = false
        self.messages[self.messages.count - 1] = messageRow
        isInteractiveWithGPT = false
        return messageRow.codeBlock
    }
    
    @MainActor
    func extractCodeBlock(response: String) -> String? {
        let pattern = "`([^`]+)`"
        let regex = try? NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: response.utf16.count)
        
        if let match = regex?.firstMatch(in: response, options: [], range: range) {
            if let range = Range(match.range(at: 1), in: response) {
                return String(response[range])
            }
        }
        
        return nil
    }
}

