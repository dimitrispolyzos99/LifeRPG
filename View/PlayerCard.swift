//
//  PlayerCard.swift
//  LifeRPG
//
//  Created by Dimitris Poluzos on 12/3/26.
//

import SwiftUI

struct PlayerCard: View {
    let name: String
    var playerHp: Int = 70
    var playerMana: Int = 20

    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(name)
                .font(.headline)
                .foregroundStyle(.white)
            
            VStack(alignment: .leading, spacing: 6) {
                Text("HP \(playerHP)")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.8))

                Text("MP \(playerMana)")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.8))
            }
        }
    }
}


#Preview {
    PlayerCard(name: "Paladin", playerHp: playerHP, playerMana: playerMana)
}
