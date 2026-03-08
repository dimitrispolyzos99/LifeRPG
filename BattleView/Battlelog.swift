//
//  Battlelog.swift
//  LifeRPG
//
//  Created by Dimitris Poluzos on 11/3/26.
//

import SwiftUI

var battleLog: [String] = []

struct Battlelog: View {
    var battleLog: [String] = []
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(Array(battleLog.enumerated()), id: \.offset) { index, log in
                        Text(log)
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .id(index)
                    }
                }
                .padding()
            }
            .frame(maxWidth: .infinity, minHeight: 70, maxHeight: 150)
            .background(Color.black.opacity(0.5))
            .cornerRadius(16)
            .onChange(of: battleLog) { oldValue, newValue in
                if let lastIndex = battleLog.indices.last {
                    withAnimation {
                        proxy.scrollTo(lastIndex, anchor: .bottom)
                    }
                }
            }
        }
        
    }
}

#Preview {
    Battlelog()
}
