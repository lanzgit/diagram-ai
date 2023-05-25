//
//  Card.swift
//  DiagramAI
//
//  Created by Vinicius Vianna on 25/05/23.
//

import Foundation
import SwiftUI

struct Card {
    let title: String
    let text: String
    let image: String
    let color: Color
    
    static let plantumlCard = Card(
        title: "PlantUML",
        text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam auctor magna et pharetra mattis.",
        image: "plantumlLogo",
        color: Color("myGreen")
    )
    
    static let openaiCard = Card(
        title: "OpenAI",
        text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam auctor magna et pharetra mattis.",
        image: "openaiLogo",
        color: Color("myPink")
    )
    
    static let tipos = Card(
        title: "Que diagramas eu posso criar?",
        text: "1. Casos de Uso\n2. Classes\n3. Sequência",
        image: "question",
        color: Color("myOrange")
        )
}
