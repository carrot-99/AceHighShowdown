//  ResultView.swift

import SwiftUI

struct ResultView: View {
    @ObservedObject var viewModel: GameViewModel
    @State private var appeared = false

    var body: some View {
        ZStack {
            FeltBackground()

            VStack(spacing: 28) {
                Spacer()

                VStack(spacing: 8) {
                    Image(systemName: headline.icon)
                        .font(.system(size: 64))
                        .foregroundColor(headline.color)
                    Text(headline.title)
                        .font(.system(size: 48, weight: .heavy, design: .rounded))
                        .foregroundColor(headline.color)
                    Text(headline.message)
                        .font(.title3.bold())
                        .foregroundColor(.white)
                }
                .scaleEffect(appeared ? 1 : 0.6)
                .opacity(appeared ? 1 : 0)
                .accessibilityElement(children: .combine)

                HStack(spacing: 16) {
                    ScoreCardView(title: viewModel.player.name, score: viewModel.player.score, isWinner: viewModel.outcome == .win)
                    Text("vs")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.7))
                    ScoreCardView(title: viewModel.cpu.name, score: viewModel.cpu.score, isWinner: viewModel.outcome == .loss)
                }

                HStack(spacing: 24) {
                    stat("難易度", viewModel.difficulty.title)
                    stat("最大連続正解", "\(viewModel.bestStreak)")
                }
                .foregroundColor(.white)

                Spacer()

                VStack(spacing: 14) {
                    Button {
                        Haptics.tap()
                        viewModel.restart()
                    } label: {
                        Label("もう一度遊ぶ", systemImage: "arrow.clockwise")
                    }
                    .buttonStyle(.primaryGame)

                    Button {
                        viewModel.quit()
                    } label: {
                        Label("タイトルに戻る", systemImage: "house.fill")
                    }
                    .buttonStyle(GameButtonStyle(background: Color.white.opacity(0.15)))
                }
                .frame(maxWidth: 420)
            }
            .padding(24)
        }
        .onAppear {
            Haptics.notify(viewModel.outcome == .loss ? .error : .success)
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) { appeared = true }
        }
    }

    private var headline: (title: String, message: String, icon: String, color: Color) {
        switch viewModel.outcome {
        case .win: return ("WIN!", "おめでとう！ あなたの勝ちです", "crown.fill", Theme.gold)
        case .loss: return ("LOSE", "残念！ CPUの勝ちです", "cloud.rain.fill", Theme.low)
        case .draw: return ("DRAW", "引き分けです", "equal.circle.fill", .white)
        }
    }

    private func stat(_ title: String, _ value: String) -> some View {
        VStack(spacing: 2) {
            Text(title).font(.caption).opacity(0.8)
            Text(value).font(.headline)
        }
        .accessibilityElement(children: .combine)
    }
}

struct ScoreCardView: View {
    let title: String
    let score: Int
    let isWinner: Bool

    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.headline)
            Text("\(score)")
                .font(.system(size: 44, weight: .bold, design: .rounded).monospacedDigit())
        }
        .foregroundColor(.white)
        .frame(minWidth: 110)
        .padding()
        .background(Color.black.opacity(0.35), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(isWinner ? Theme.gold : .clear, lineWidth: 3)
        )
        .accessibilityElement(children: .combine)
    }
}
