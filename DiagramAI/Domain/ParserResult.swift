//
//  ParserResult.swift
//  DiagramAI
//
//  Created by Vinicius Vianna on 07/05/23.
//

import Foundation

struct ParserResult: Identifiable {
    
    let id = UUID()
    let attributedString: AttributedString
    let isCodeBlock: Bool
    let codeBlockLanguage: String?
    
}
