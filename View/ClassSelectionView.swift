//
//  ClassSelectionView.swift
//  LifeRPG
//
//  Created by Dimitris Poluzos on 12/3/26.
//

import SwiftUI

struct ClassSelectionView: View {
    @ObservedObject var battle: BattleViewModel
    
    var body: some View {
        ZStack {
            Color.brown
                .ignoresSafeArea()
            VStack(spacing: 30) {
                Image("Life_RPG")
                    .resizable()
                    .scaledToFit()
                VStack(spacing: 16){
                    Text("Choose your class")
                        .font(Font.largeTitle.bold())
                        .foregroundColor(.black)
                    HStack{
                        NavigationLink(destination: ContentView()) {
                            ActionButton2(title: "Warrior")
                        }
//                        .simultaneousGesture(TapGesture().onEnded {
//                            battle.applyClass(.warrior)
//                        })
                        NavigationLink(destination: ContentView()) {
                            ActionButton2(title: "Mage")
                        }
//                        .simultaneousGesture(TapGesture().onEnded {
//                            battle.applyClass(.mage)
//                        })
                    }
                    HStack{
                        NavigationLink(destination: ContentView()) {
                            ActionButton2(title: "Paladin")
                        }
//                        .simultaneousGesture(TapGesture().onEnded {
//                            battle.applyClass(.paladin)
//                        })
                        NavigationLink(destination: ContentView()) {
                            ActionButton2(title: "Rogue")
                        }
//                        .simultaneousGesture(TapGesture().onEnded {
//                            battle.applyClass(.rogue)
//                        })
                    }
                }
            }
        }
    }
}
#Preview {
    ClassSelectionView(battle: BattleViewModel())
}
