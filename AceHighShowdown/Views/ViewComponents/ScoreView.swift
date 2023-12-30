//  ScoreView.swift

import Foundation
import SwiftUI

struct ScoreView: View {
    var playerName: String
    var cardsRemaining: Int
    var score: Int
    
    var body: some View {
        HStack {
            Text("\(playerName)")
                .font(.headline)
            Spacer()
            VStack {
                Text("スコア: \(score)")
                Text("残り枚数: \(cardsRemaining)")
                    .font(.subheadline)
            }

        }
        .padding(.horizontal)
        .foregroundColor(.black)
    }
}
