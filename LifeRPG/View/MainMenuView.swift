//
//  MainMenu.swift
//  LifeRPG
//
//  Created by Dimitris Poluzos on 12/3/26.
//

import SwiftUI

struct MainMenuView: View {
    @StateObject var battle = BattleViewModel()
    var body: some View {
        NavigationStack {
            ZStack {
                Color.brown
                    .ignoresSafeArea()
                VStack(spacing: 30) {
                    Image("Life_RPG")
                        .resizable()
                        .scaledToFit()

                    VStack(spacing: 16) {
                        
                        NavigationLink(destination: BattleView(battle: battle)) {
                            ActionButton2(title: "Continue")
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            battle.loadGame()
                            battle.respawnEnemy()
                        })
                        
                        NavigationLink(destination: ClassSelectionView(battle: BattleViewModel())) {
                            ActionButton2(title: "New Game")
                        }

                        NavigationLink(destination: ClassSelectionView(battle: BattleViewModel())) {
                            ActionButton2(title: "Settings")
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

#Preview {
    MainMenuView(battle: BattleViewModel())
}
