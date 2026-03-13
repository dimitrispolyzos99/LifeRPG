//
//  ContentView.swift
//  LifeRPG
//
//  Created by Dimitris Poluzos on 8/3/26.
//

import SwiftUI

struct BattleView: View {
    @StateObject var battle = BattleViewModel()
    
    var body: some View {
        
        VStack {
            HStack(alignment: .top, spacing: 12){
                PlayerBar(playerHP: battle.player.hp,
                          playerMana: battle.player.mana,
                          playerHit: battle.playerHit)
                .frame(maxWidth: .infinity)
                
                EnemyBar(enemyHP: battle.enemy.hp,
                         enemyHit: battle.enemyHit)
                .frame(maxWidth: .infinity)

            }

            
            BattlelogView(battleLog: battle.battleLog)
            
            BattleField(enemyHit: battle.enemyHit, enemyIsAlive: battle.enemy.isAlive)
            
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
                xp: battle.player.xp,
                level: battle.player.level,
                playerHp: battle.player.hp,
                playerMana: battle.player.mana
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
    BattleView()
}
