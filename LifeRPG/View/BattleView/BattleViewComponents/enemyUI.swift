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
                if battle.enemy.isAlive{
                    Image("murloc")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 250)
                        .offset(x: -15, y: 20)
                        .offset(x: battle.enemyHit ? 15 : 5, y:10)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .animation(.easeInOut(duration: 0.88), value: battle.enemyHit)
            .opacity(battle.enemy.isAlive ? 1 : 0)
            .animation(.easeOut(duration: 0.3), value: battle.enemy.isAlive)
        }
    }
}

struct EnemyBar : View {

    @ObservedObject var battle: BattleViewModel

    
    var body: some View {
        VStack(spacing: 10){
            
            Text("Murloc")
                .font(.headline)
                .bold()
            Text("HP \(battle.enemy.hp)/\(battle.maxEnemyHP)")
                .font(.caption)
            ProgressView(value: Double(battle.enemy.hp), total: Double(battle.maxEnemyHP))
                    .tint(.red)
                    .padding()
                    .frame(height: 6)
            Text("MP \(battle.enemy.mana)/20")
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
    VStack {
        BattleField(battle: BattleViewModel())
        EnemyBar(battle: BattleViewModel())
    }
}
