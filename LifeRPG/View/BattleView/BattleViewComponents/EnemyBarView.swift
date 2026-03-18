//
//  EnemyBarUI.swift
//  LifeRPG
//
//  Created by Dimitris Poluzos on 18/3/26.
//

import SwiftUI


struct EnemyBar : View {

    @ObservedObject var battle: BattleViewModel

    
    var body: some View {
        VStack(spacing: 10){
            
            Text("\(battle.enemy.name)")
                .font(.headline)
                .bold()
            Text("HP \(battle.enemy.hp)/\(battle.maxEnemyHP)")
                .font(.caption)
            ProgressView(value: Double(battle.enemy.hp), total: Double(battle.maxEnemyHP))
                    .tint(.red)
                    .padding()
                    .frame(height: 6)
            Text("MP \(battle.enemy.mana)/\(battle.enemy.mana)")
                .font(.caption)
            ProgressView(value: Double(battle.enemy.mana), total: 20)
                    .tint(.blue)
                    .padding()
                    .frame(height: 9)

        }
        .background(battle.enemyHit ? Color.red.opacity(0.5) : Color.green.opacity(0.4))
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(Color.green.opacity(0.4)),
                            Color(Color.black)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        )
        .cornerRadius(16)
        .padding(10)
        .offset(x: battle.enemyHit ? 6 : 0)
        .animation(.easeInOut(duration: 0.15), value: battle.enemyHit)

        }
    }
#Preview {
    EnemyBar(battle: BattleViewModel())
}
