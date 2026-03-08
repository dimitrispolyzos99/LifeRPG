//
//  SwiftUIView.swift
//  LifeRPG
//
//  Created by Dimitris Poluzos on 9/3/26.
//

import SwiftUI

var enemyHP = 50
var enemyHit = false
var enemyIsAlive = true

struct BattleField : View {
    var enemyHit = false
    var enemyIsAlive = true
    
    var body: some View {
        
        VStack {
            ZStack{
                if enemyIsAlive{
                    Image("murloc")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 250)
                        .offset(x: -15, y: 20)
                        .offset(x: enemyHit ? 15 : 5, y:10)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .animation(.easeInOut(duration: 0.88), value: enemyHit)
            .opacity(enemyIsAlive ? 1 : 0)
            .animation(.easeOut(duration: 0.3), value: enemyIsAlive)
        }
    }
}

struct EnemyBar : View {
    var enemyHP = 50
    var enemyMana = 20
    var enemyHit = false
    
    var body: some View {
        VStack(spacing: 10){
            
            Text("Murloc")
                .font(.headline)
                .bold()
            Text("HP \(enemyHP)/50")
                .font(.caption)
                ProgressView(value: Double(enemyHP), total: 50)
                    .tint(.red)
                    .padding()
                    .frame(height: 6)
            Text("MP \(enemyMana)/20")
                .font(.caption)
                ProgressView(value: Double(enemyMana), total: 20)
                    .tint(.blue)
                    .padding()
                    .frame(height: 9)

        }
        .background(enemyHit ? Color.red.opacity(0.5) : Color.green.opacity(0.4))
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
        .offset(x: enemyHit ? 6 : 0)
        .animation(.easeInOut(duration: 0.15), value: enemyHit)

        }
    }




#Preview {
    BattleField()
    EnemyBar(enemyHP: enemyHP, enemyHit: enemyHit)
}

