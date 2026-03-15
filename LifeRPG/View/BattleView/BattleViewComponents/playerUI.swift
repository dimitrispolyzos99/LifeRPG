//
//  playerUI.swift
//  LifeRPG
//
//  Created by Dimitris Poluzos on 9/3/26.
//

import SwiftUI



struct PlayerBar : View {

    @ObservedObject var battle: BattleViewModel
    
       
    var body: some View {
        VStack(spacing: 10){
            
            
            Text(battle.player.playerClass.name)
                .font(.headline)
                .bold()
            Text("HP \(battle.player.hp)/\(battle.maxPlayerHP)")
                .font(.caption)
            ProgressView(value: Double(battle.player.hp), total: Double(battle.maxPlayerHP))
                    .tint(.red)
                    .padding()
                    .frame(height: 6)
            Text("MP \(battle.player.mana)/\(battle.maxPlayerMana)")
                .font(.caption)
            ProgressView(value: Double(battle.maxPlayerMana), total: Double(battle.maxPlayerMana))
                    .tint(.blue)
                    .padding()
                    .frame(height: 9)

        }
        .background(battle.playerHit ? Color.red.opacity(0.5) : Color.purple.opacity(0.4))
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(Color.purple.opacity(0.4)),
                            Color(Color.black)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        )
        .cornerRadius(16)
        .padding(10)
        .offset(x: battle.playerHit ? 6 : 0)
        .animation(.easeInOut(duration: 0.15), value: battle.playerHit)
    }
    
}



#Preview {
    PlayerBar(battle: BattleViewModel())
}


