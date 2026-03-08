//
//  ContentView.swift
//  LifeRPG
//
//  Created by Dimitris Poluzos on 8/3/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject var battle = BattleViewModel()
    
    var body: some View {
        
        VStack {
            HStack(alignment: .top, spacing: 12){
                PlayerBar(playerHP: battle.playerHP,
                          playerMana: battle.playerMana,
                          playerHit: battle.playerHit)
                .frame(maxWidth: .infinity)
                
                EnemyBar(enemyHP: battle.enemyHP,
                         enemyHit: battle.enemyHit)
                .frame(maxWidth: .infinity)

            }

            
            Battlelog(battleLog: battle.battleLog)
            
            BattleField(enemyHit: battle.enemyHit, enemyIsAlive: battle.enemyIsAlive)
            
            Spacer()
            
            ActionBar(
                onAttack: {
                    battle.attackMurloc()
                }, onPotion: {
                    battle.usePotion()
                }, onJudgement: {
                    battle.judgement()
                }, onHolyLight: {
                    battle.holyLight()
                },
                xp: battle.xp,
                level: battle.level,
                playerHp: battle.playerHP,
                playerMana: battle.playerMana
            )
            if battle.isGameOver{
                Button("Restart Battle") {
                    battle.restartBattle()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.red)
                .foregroundColor(.black)
                .cornerRadius(16)
            }
        }
        .padding()
        .background{

            ZStack {
                Image("forestBG1")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                Color.black.opacity(0.45)
                    .ignoresSafeArea()
            }
        }
        
    }

}

#Preview {
    ContentView()
}
