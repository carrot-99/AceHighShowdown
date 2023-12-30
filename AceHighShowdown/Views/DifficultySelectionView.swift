//  DifficultySelectionView.swift

import SwiftUI

struct DifficultySelectionView: View {
    @Binding var isGameActive: Bool
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        GeometryReader { geometry in
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    
                    Text("難易度を選択してください")
                        .font(.largeTitle)
                        .padding()
                    
                    Button("EASY") {
                        selectDifficulty(.easy)
                    }
                    .buttonStyle(DifficultyButtonStyle(width: geometry.size.width * 0.8))
                    
                    Button("NORMAL") {
                        selectDifficulty(.normal)
                    }
                    .buttonStyle(DifficultyButtonStyle(width: geometry.size.width * 0.8))
                    
                    Button("HARD") {
                        selectDifficulty(.hard)
                    }
                    .buttonStyle(DifficultyButtonStyle(width: geometry.size.width * 0.8))
                    
                    Spacer()
                }
                Spacer()
            }
        }
    }

    // 難易度を選択したときの処理
    func selectDifficulty(_ difficulty: Difficulty) {
        viewModel.difficulty = difficulty
        isGameActive = true
    }
}

// 難易度選択ボタンのスタイル定義
struct DifficultyButtonStyle: ButtonStyle {
    var width: CGFloat
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding()
            .frame(width: width)
            .contentShape(Rectangle())
            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(15)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .padding()
    }
}
