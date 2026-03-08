//
//  actionBar.swift
//  LifeRPG
//
//  Created by Dimitris Poluzos on 10/3/26.
//

import SwiftUI

var level = 1
var xp = 0

struct ActionBar : View {
    let onAttack: () -> Void
    let onPotion: () -> Void
    let onJudgement: () -> Void
    let onHolyLight: () -> Void
    
    var xp : Int
    var level : Int
    var playerHp: Int
    var playerMana: Int

    private var isAttackDisabled: Bool {
        playerHp == 0
    }
    private var isPotionDisabled: Bool {
        playerHp == 0
    }
    private var isJudgementDisabled: Bool {
        playerMana < 5 || playerHp == 0
    }
    private var isHolyLightDisabled: Bool {
        playerMana < 10 || playerHp == 0
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
                Text("Level: \(level)")
                    .font(.title3)
                    .foregroundColor(.white)
                    .bold()
                
                ProgressView(value: Double(xp), total:Double((100 * level)))
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
    ActionBar(onAttack: {}, onPotion: {}, onJudgement: {}, onHolyLight: {}, xp: xp, level: level,playerHp: playerHP,playerMana: playerMana)
}
