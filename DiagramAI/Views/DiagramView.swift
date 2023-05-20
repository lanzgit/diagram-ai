//
//  DiagramView.swift
//  DiagramAI
//
//  Created by Vinicius Vianna on 11/05/23.
//

import SwiftUI

struct DiagramView: View {
    @State private var plantUMLCode: String = ""
    @State private var diagramImage: UIImage? = nil
    @State private var currentTab: Tab = .Diagram
    
    let img: UIImage?
    init(img: UIImage?) {
        self.img = img
    }
    
    var body: some View {
        VStack {
            Text("PlantUML code:")
            TextEditor(text: $plantUMLCode)
                .frame(height: 400)
                .border(Color.gray, width: 1)
            
            Button("Gerar Diagrama", action: generateDiagram)
            
            if let img = img {
                Image(uiImage: img)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Text("error")
            }
        }
        .padding()
    }
    
    func generateDiagram() {
        let encodedUMLCode = plantUMLCode.data(using: .utf8)?.base64EncodedString() ?? ""
        let newEncodedUML = PlantUMLEncode().compressAndEncode(plantUMLCode)
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



struct DiagramView_Previews: PreviewProvider {
    static var previews: some View {
        let imgPreview: UIImage? = nil
        DiagramView(img: imgPreview)
    }
}
