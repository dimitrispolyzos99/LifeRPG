//
//  SwiftUIView.swift
//  LifeRPG
//
//  Created by Dimitris Poluzos on 9/3/26.
//

import SwiftUI


struct BattleField : View {
    
    @ObservedObject var battle: BattleViewModel
    
    var body: some View {
        
        VStack {
            ZStack{
                HStack{
                    
                        Image("\(battle.player.playerClass.name)")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 250)
                            .offset(x: -15, y: 20)
                            .offset(x: battle.playerHit ? -15 : 5, y:10)
                            .frame(maxWidth: .infinity)
                    
                        Image("\(battle.enemy.name)")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 250)
                            .offset(x: -15, y: 20)
                            .offset(x: battle.enemyHit ? 15 : 5, y:10)
                            .frame(maxWidth: .infinity)
                            .opacity(battle.enemy.isAlive ? 1 : 0)
                            .animation(.easeOut(duration: 0.3), value: battle.enemy.isAlive)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .animation(.easeInOut(duration: 0.88), value: battle.enemyHit)
            
        }
    }
}






#Preview {
    VStack {
        BattleField(battle: BattleViewModel())
    }
}
