//
//  NavigationBar.swift
//  DiagramAI
//
//  Created by Vinicius Vianna on 11/05/23.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case Home = "house"
    case Diagram = "cube"
    case Chat = "message"
    
    var tabName: String {
        switch self {
        case .Home:
            return "Home"
        case .Diagram:
            return "Diagram"
        case .Chat:
            return "Chat"
        }
    }
}

struct NavigationBar: View {
    @Binding var selectedTab: Tab
    private var fillImage: String {
        selectedTab.rawValue + ".fill"
    }
    
    var title = ""
    
    var body: some View {
        ZStack {
            HStack {
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    Spacer()
                    tabButton(tab: tab)
                }
                
            }
            .frame(width: nil, height: 60)
            .background(.thinMaterial)
            .cornerRadius(10)
            .padding()
        }
        .frame(height: 60)
        .frame(maxHeight: 60, alignment: .bottom)
    }
    
    func tabButton(tab: Tab) -> some View {
        GeometryReader { proxy in
            Button(action: {
                withAnimation(.spring()) {
                    selectedTab = tab
                }
            }, label: {
                VStack(spacing: 0) {
                    Image(systemName: selectedTab == tab ? fillImage : tab.rawValue)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 60)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .scaleEffect(tab ==  selectedTab ? 1.25 : 1.0)
                        .foregroundColor(selectedTab == tab ? .purple : .gray)
                        .font(.system(size: 22))
                        .onTapGesture {
                            withAnimation(.easeIn(duration: 0.1)) {
                                selectedTab = tab
                            }
                        }
                        .background(
                            ZStack {
                                if selectedTab == tab {
                                    Text(selectedTab.tabName)
                                        .foregroundColor(.primary)
                                        .font(.footnote)
                                        .padding(.top, 50)
                                }
                            })
                }
            })
        }
        }
    }
    

struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBar(selectedTab: .constant(.Home), title: "diagram.ai")
    }
}
