//
//  playerUI.swift
//  LifeRPG
//
//  Created by Dimitris Poluzos on 9/3/26.
//

import SwiftUI


var playerHP = 70
var playerMana = 20
var playerHit = false



struct PlayerBar : View {

    var playerHP : Int
    var playerMana : Int
    var playerHit : Bool
    
    var body: some View {
        VStack(spacing: 10){
            

            Text("Paladin")
                .font(.headline)
                .bold()
            Text("HP \(playerHP)/70")
                .font(.caption)
                ProgressView(value: Double(playerHP), total: 70)
                    .tint(.red)
                    .padding()
                    .frame(height: 6)
            Text("MP \(playerMana)/20")
                .font(.caption)
                ProgressView(value: Double(playerMana), total: 20)
                    .tint(.blue)
                    .padding()
                    .frame(height: 9)

        }
        .background(playerHit ? Color.red.opacity(0.5) : Color.purple.opacity(0.4))
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
        .offset(x: playerHit ? 6 : 0)
        .animation(.easeInOut(duration: 0.15), value: playerHit)
    }
    
}






#Preview {
    PlayerBar(playerHP: playerHP, playerMana: playerMana, playerHit: playerHit)

}
