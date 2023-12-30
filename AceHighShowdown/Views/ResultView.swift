//  ResultView.swift

import SwiftUI

struct ResultView: View {
    @ObservedObject var viewModel: GameViewModel
    var userScore: Int
    var cpuScore: Int
    @Binding var isGameActive: Bool

    var body: some View {
        VStack(spacing: 20) {
            Text("ゲーム終了")
                .font(.system(size: 34, weight: .heavy))
                .foregroundColor(Color.purple)
                .padding()
                .scaleEffect(1.2)
                .animation(.easeInOut(duration: 1).repeatCount(1, autoreverses: true))

            Text("最終スコア")
                .font(.system(size: 28, weight: .semibold))
                .foregroundColor(Color.orange)
                .padding()

            HStack {
                ScoreCardView(title: "あなた", score: userScore, color: .blue)
                ScoreCardView(title: "CPU", score: cpuScore, color: .red)
            }
            .padding(.horizontal)

            resultMessage
                .font(.title2)
                .padding()
                .transition(.opacity)

            restartButton
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient(gradient: Gradient(colors: [Color.gray.opacity(0.1), Color.gray.opacity(0.3)]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .edgesIgnoringSafeArea(.all)
    }

    var resultMessage: some View {
        Group {
            if userScore > cpuScore {
                Text("おめでとう！ あなたの勝ちです！")
                    .foregroundColor(.green)
            } else if userScore < cpuScore {
                Text("残念！ CPUの勝ちです！")
                    .foregroundColor(.red)
            } else {
                Text("引き分けです！")
            }
        }
        .font(.title2)
        .multilineTextAlignment(.center)
        .padding()
        .background(userScore == cpuScore ? Color.yellow : (userScore > cpuScore ? Color.green.opacity(0.2) : Color.red.opacity(0.2)))
        .cornerRadius(20)
        .shadow(radius: 10)
    }

    var restartButton: some View {
        Button(action: {
            withAnimation {
                viewModel.updateRecords()
                viewModel.resetGame()
                isGameActive = false
            }
        }) {
            Text("タイトルに戻る")
                .foregroundColor(.white)
                .bold()
                .padding()
                .frame(maxWidth: .infinity)
                .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(10)
                .shadow(radius: 10)
        }
    }
}

struct ScoreCardView: View {
    var title: String
    var score: Int
    var color: Color

    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .foregroundColor(color)
            Text("\(score)")
                .font(.largeTitle)
                .bold()
                .foregroundColor(color)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}
