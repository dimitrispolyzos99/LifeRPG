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
            

            Text("Paladin")
                .font(.headline)
                .bold()
            Text("HP \(battle.player.hp)/70")
                .font(.caption)
            ProgressView(value: Double(battle.player.hp), total: 70)
                    .tint(.red)
                    .padding()
                    .frame(height: 6)
            Text("MP \(battle.player.mana)/20")
                .font(.caption)
            ProgressView(value: Double(battle.player.mana), total: 20)
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


