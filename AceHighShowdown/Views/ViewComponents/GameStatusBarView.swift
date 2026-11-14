//  GameStatusBarView.swift

import SwiftUI

/// ゲーム画面上部のバー（中断・ラウンド数・出たカード）
struct GameStatusBarView: View {
    let round: Int
    let totalRounds: Int
    let difficulty: Difficulty
    let status: String
    let onQuit: () -> Void
    let onShowPlayedCards: () -> Void

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                iconButton("xmark", label: "ゲームを中断", action: onQuit)
                Spacer()
                VStack(spacing: 2) {
                    Text("ラウンド \(round) / \(totalRounds)")
                        .font(.subheadline.bold().monospacedDigit())
                    Text(difficulty.title)
                        .font(.caption2.bold())
                        .foregroundColor(Theme.gold)
                }
                Spacer()
                iconButton("square.grid.3x3.fill", label: "出たカードを見る", action: onShowPlayedCards)
            }

            ProgressView(value: Double(round), total: Double(totalRounds))
                .tint(Theme.gold)

            Text(status)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(Color.black.opacity(0.3), in: RoundedRectangle(cornerRadius: 10))
                .animation(nil, value: status)
        }
        .foregroundColor(.white)
    }

    private func iconButton(_ systemName: String, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.headline)
                .frame(width: 40, height: 40)
                .background(Color.black.opacity(0.3), in: Circle())
        }
        .accessibilityLabel(label)
    }
}
