//  ActionButton.swift

//  LifeRPG

//

//  Created by Dimitris Poluzos on 12/3/26.

//


import SwiftUI

struct ActionButton2: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.system(size: 17, weight: .semibold))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.42, green: 0.06, blue: 0.10),
                                Color(red: 0.24, green: 0.03, blue: 0.06)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.25), radius: 8, y: 4)
    }
}

#Preview {
    ActionButton2(title: "Test Button")
}
