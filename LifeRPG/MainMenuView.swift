//
//  MainMenu.swift
//  LifeRPG
//
//  Created by Dimitris Poluzos on 12/3/26.
//

import SwiftUI

struct MainMenu: View {
    var body: some View {
        NavigationStack{
            
            
            ZStack {
                Color.brown
                    .ignoresSafeArea()
                VStack(spacing: 30) {
                    Image("Life_RPG")
                        .resizable()
                        .scaledToFit()
                    
                    VStack(spacing: 16) {
                        ActionButton(title: "New Game") {
                            
                        }
                        ActionButton(title: "Load Game"){
                            
                        }
                        ActionButton(title: "Settings") {
                            
                        }
                    }
                }
            }
        }
    }
}
#Preview {
    MainMenu()
}
