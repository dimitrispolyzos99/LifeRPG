//
//  actionBar.swift
//  LifeRPG
//
//  Created by Dimitris Poluzos on 10/3/26.
//

import SwiftUI


struct ActionBar : View {
    let onAttack: () -> Void
    let onPotion: () -> Void
    let onJudgement: () -> Void
    let onHolyLight: () -> Void
    
    @ObservedObject var battle: BattleViewModel
    
    private var isAttackDisabled: Bool {
        battle.player.hp == 0
    }
    private var isPotionDisabled: Bool {
        battle.player.hp == 0
    }
    private var isJudgementDisabled: Bool {
        battle.player.mana < 5 || battle.player.hp == 0
    }
    private var isHolyLightDisabled: Bool {
        battle.player.mana < 10 || battle.player.hp == 0
    }
    
    var body: some View {
        VStack(spacing: 12){
            HStack(spacing: 12){
                ActionButton(title: "Attack"){
                    onAttack()
                }
                .frame(maxWidth: .infinity)
                .disabled(isAttackDisabled)
                
                ActionButton(title: "Health Potion"){
                    onPotion()
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .cornerRadius(20)
                .disabled(isAttackDisabled)
            }
            HStack(spacing: 12){
                ActionButton(title:"Judgement"){
                    onJudgement()
                }
                .frame(maxWidth: .infinity)
                .disabled(isJudgementDisabled)
                
                ActionButton(title:"Holy Light"){
                    onHolyLight()
                }
                .frame(maxWidth: .infinity)
                .disabled(isHolyLightDisabled)
            }
            VStack(spacing: 4){
                Text("Level: \(battle.player.level)")
                    .font(.title3)
                    .foregroundColor(.white)
                    .bold()
                
                ProgressView(value: Double(battle.player.xp), total:Double((100 * battle.player.level)))
                    .tint(.green)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: 0)
            }
        }
        .padding()
        .cornerRadius(30)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black.opacity(0.7))
        )
    }
}


#Preview {
    ActionBar(onAttack: {}, onPotion: {}, onJudgement: {}, onHolyLight: {}, battle: BattleViewModel())
}
