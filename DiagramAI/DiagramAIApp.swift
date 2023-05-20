//
//  DiagramAIApp.swift
//  DiagramAI
//
//  Created by Vinicius Vianna on 06/05/23.
//

import SwiftUI
import OpenAIKit

@main
struct DiagramAIApp: App {
    var body: some Scene {
        WindowGroup {
            SplashView(vm: ContentViewModel(api: ChatGPTAPI(apiKey: Constants.openAIKey)))
        }
    }
}
