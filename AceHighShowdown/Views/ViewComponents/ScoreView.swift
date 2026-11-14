//  ScoreView.swift

import SwiftUI

/// プレイヤー名・ポイント・残り枚数を表示するパネル
struct ScoreView: View {
    let player: Player
    let isActive: Bool
    var streak: Int = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 6) {
                Text(player.name)
                    .font(.headline)
                if isActive {
                    Text("の番")
                        .font(.caption.bold())
                        .foregroundColor(Theme.gold)
                }
            }
            Text("\(player.score)")
                .font(.system(size: 32, weight: .bold, design: .rounded).monospacedDigit())
            Text("残り \(player.hand.count) 枚")
                .font(.caption)
                .opacity(0.8)
            if streak >= 2 {
                Label("\(streak) 連続正解", systemImage: "flame.fill")
                    .font(.caption.bold())
                    .foregroundColor(.orange)
            }
        }
        .foregroundColor(.white)
        .padding(12)
        .frame(minWidth: 110, alignment: .leading)
        .background(Color.black.opacity(0.35), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(isActive ? Theme.gold : .clear, lineWidth: 2)
        )
        .animation(.easeInOut, value: player.score)
        .accessibilityElement(children: .combine)
    }
}
