//  ChoiceResultView.swift

import SwiftUI

/// ラウンドの正解 / 不正解を表示するバッジ
struct ChoiceResultView: View {
    let isCorrect: Bool
    let guesserName: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                .font(.title)
            VStack(alignment: .leading, spacing: 0) {
                Text(isCorrect ? "正解！" : "ハズレ")
                    .font(.title2.bold())
                Text(guesserName)
                    .font(.caption)
                    .opacity(0.85)
            }
        }
        .foregroundColor(.white)
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(isCorrect ? Color.green : Color.red, in: Capsule())
        .shadow(color: .black.opacity(0.3), radius: 6, y: 3)
        .accessibilityElement(children: .combine)
    }
}

/// HIGH / LOW の予想を示すチップ
struct GuessChip: View {
    let guess: Guess
    let label: String

    var body: some View {
        HStack(spacing: 4) {
            Text(label)
                .font(.caption)
            Image(systemName: guess == .high ? "arrow.up" : "arrow.down")
            Text(guess.rawValue)
        }
        .font(.subheadline.bold())
        .foregroundColor(.white)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Theme.color(for: guess), in: Capsule())
        .accessibilityElement(children: .combine)
    }
}
