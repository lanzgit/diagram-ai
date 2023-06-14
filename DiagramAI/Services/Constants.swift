//
//  Constants.swift
//  DiagramAI
//
//  Created by Vinicius Vianna on 08/05/23.
//

import Foundation

//TODO: entrar com uma key valida, a openAI dropa a key em um repositorio do git publico
enum Constants {
    static let openAIKey = "OPENAI_KEY_HERE"
}

enum DiagramType: String, CaseIterable {
    case Sequence
    case Usecase
    case Class
    
    var diagramName: String {
        switch self {
            case .Sequence:
                return "sequence diagram"
            case .Class:
                return "class diagram"
            case .Usecase:
                return "usecase diagram"
        }
    }
}
