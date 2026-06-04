//
//  ContentView.swift
//  LifeRPG
//
//  Created by Dimitris Polyzos on 8/3/26.
//

import SwiftUI

struct BattleView: View {
    @ObservedObject var battle: BattleViewModel
    
    var body: some View {
        
        VStack {
            HStack(alignment: .top, spacing: 12){
                PlayerBar(viewModel: battle)
                .frame(maxWidth: .infinity)
                
                EnemyBar(battle: battle)
                .frame(maxWidth: .infinity)

            }
            Text ("STAGE \(battle.player.stage)")
                .font(.headline)
                .bold()
                .foregroundColor(.white)

            
            BattlelogView(battleLog: battle.battleLog.battleLog)
            
            BattleField(battle: battle)
            
            Spacer()
            
            ActionBar(
                onAttack: battle.attackEnemy,
                onPotion: battle.usePotion,
                battle: battle
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
                Image("\(battle.currentArena)")
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
    BattleView(battle: BattleViewModel())
}
