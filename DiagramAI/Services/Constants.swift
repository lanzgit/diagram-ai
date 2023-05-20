//
//  Constants.swift
//  DiagramAI
//
//  Created by Vinicius Vianna on 08/05/23.
//

import Foundation

enum Constants {
    static let openAIKey = "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"
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
