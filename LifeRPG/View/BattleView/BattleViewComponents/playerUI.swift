//
//  playerUI.swift
//  LifeRPG
//
//  Created by Dimitris Poluzos on 9/3/26.
//

import SwiftUI

@MainActor
struct PlayerBar : View {

    @ObservedObject var viewModel: BattleViewModel
    
       
    var body: some View {
        VStack(spacing: 10){
            
            
            Text(viewModel.player.playerClass.name)
                .font(.headline)
                .bold()
            Text("HP \(viewModel.player.hp)/\(viewModel.player.maxHP)")
                .font(.caption)
            ProgressView(value: Double(viewModel.player.hp), total: Double(viewModel.player.maxHP))
                    .tint(.red)
                    .padding()
                    .frame(height: 6)
            Text("MP \(viewModel.player.mana)/\(viewModel.player.maxMana)")
                .font(.caption)
            ProgressView(value: Double(viewModel.player.mana), total: Double(viewModel.player.maxMana))
                    .tint(.blue)
                    .padding()
                    .frame(height: 9)

        }
        .background(viewModel.playerHit ? Color.red.opacity(0.5) : Color.black.opacity(0.2))
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color("\(viewModel.classColor)"),
                            Color(Color.gray.opacity(0.6))
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        )
        .cornerRadius(16)
        .padding(10)
        .offset(x: viewModel.playerHit ? 6 : 0)
        .animation(.easeInOut(duration: 0.15), value: viewModel.playerHit)
    }
    
}



#Preview {
    PlayerBar(viewModel: BattleViewModel())
}
