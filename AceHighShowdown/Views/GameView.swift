// GameView.swift

import SwiftUI

struct GameView: View {
    @ObservedObject var viewModel: GameViewModel
    @State private var showingQuitConfirmation = false
    @State private var showingPlayedCards = false

    var body: some View {
        GeometryReader { geometry in
            let cardWidth = min(geometry.size.width * 0.24, geometry.size.height * 0.15)

            ZStack {
                FeltBackground()

                VStack(spacing: 12) {
                    GameStatusBarView(
                        round: viewModel.round,
                        totalRounds: GameViewModel.totalRounds,
                        difficulty: viewModel.difficulty,
                        status: viewModel.statusText,
                        onQuit: { showingQuitConfirmation = true },
                        onShowPlayedCards: { showingPlayedCards = true }
                    )

                    Spacer(minLength: 0)

                    // CPU
                    HStack(alignment: .center, spacing: 12) {
                        ScoreView(player: viewModel.cpu, isActive: !viewModel.isPlayerTurn)
                        Spacer(minLength: 0)
                        if let card = viewModel.cpuCard {
                            CardView(card: card, isFaceUp: viewModel.isCpuCardFaceUp)
                                .id(card.id)
                                .frame(width: cardWidth)
                        }
                        DeckStackView(count: viewModel.cpu.hand.count)
                            .frame(width: cardWidth * 0.8)
                    }

                    centerArea
                        .frame(height: 70)

                    // あなた
                    HStack(alignment: .center, spacing: 12) {
                        DeckStackView(count: viewModel.player.hand.count)
                            .frame(width: cardWidth * 0.8)
                        if let card = viewModel.playerCard {
                            CardView(card: card, isFaceUp: viewModel.isPlayerCardFaceUp)
                                .id(card.id)
                                .frame(width: cardWidth)
                        }
                        Spacer(minLength: 0)
                        ScoreView(player: viewModel.player, isActive: viewModel.isPlayerTurn, streak: viewModel.streak)
                    }

                    Spacer(minLength: 0)

                    actionButtons
                        .frame(maxWidth: 520)
                }
                .padding()
            }
        }
        .confirmationDialog("ゲームを中断しますか？", isPresented: $showingQuitConfirmation, titleVisibility: .visible) {
            Button("中断してタイトルへ", role: .destructive) { viewModel.quit() }
            Button("続ける", role: .cancel) {}
        } message: {
            Text("このゲームの結果は戦績に記録されません。")
        }
        .sheet(isPresented: $showingPlayedCards) {
            PlayedCardsView(knownCards: viewModel.knownCards)
        }
        .onChange(of: viewModel.guessWasCorrect) { correct in
            guard let correct else { return }
            // ユーザー視点で良い結果（自分が当てた / CPUが外した）なら成功フィードバック
            let goodForPlayer = viewModel.isPlayerTurn == correct
            Haptics.notify(goodForPlayer ? .success : .error)
        }
    }

    // MARK: - 中央（予想と結果）

    @ViewBuilder
    private var centerArea: some View {
        let guesserName = viewModel.isPlayerTurn ? "あなたの予想" : "CPUの予想"
        HStack(spacing: 12) {
            if let guess = viewModel.guess {
                GuessChip(guess: guess, label: guesserName)
                    .transition(.scale.combined(with: .opacity))
            }
            if let correct = viewModel.guessWasCorrect {
                ChoiceResultView(isCorrect: correct, guesserName: viewModel.isPlayerTurn ? "あなた" : "CPU")
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.7), value: viewModel.guessWasCorrect)
        .animation(.spring(response: 0.35, dampingFraction: 0.7), value: viewModel.guess)
    }

    // MARK: - 操作ボタン

    @ViewBuilder
    private var actionButtons: some View {
        switch viewModel.phase {
        case .playerGuessing:
            HStack(spacing: 14) {
                guessButton(.high)
                guessButton(.low)
            }
        case .cpuGuessed:
            Button {
                Haptics.tap()
                viewModel.revealCpuCard()
            } label: {
                Label("CPUのカードをオープン", systemImage: "eye.fill")
            }
            .buttonStyle(.primaryGame)
        case .roundResult:
            Button {
                Haptics.tap()
                viewModel.nextRound()
            } label: {
                if viewModel.isLastRound {
                    Label("最終結果を見る", systemImage: "flag.checkered")
                } else {
                    Label("次のラウンドへ", systemImage: "arrow.right")
                }
            }
            .buttonStyle(GameButtonStyle(background: viewModel.isLastRound ? AnyShapeStyle(Theme.gold) : AnyShapeStyle(Theme.primaryGradient),
                                         foreground: viewModel.isLastRound ? .black : .white))
        case .notStarted, .gameOver:
            EmptyView()
        }
    }

    private func guessButton(_ guess: Guess) -> some View {
        Button {
            viewModel.submitGuess(guess)
        } label: {
            VStack(spacing: 2) {
                Image(systemName: guess == .high ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                    .font(.title2)
                Text(guess.rawValue)
                    .font(.headline)
            }
            .padding(.vertical, 6)
        }
        .buttonStyle(GameButtonStyle(background: Theme.color(for: guess)))
        .accessibilityLabel(guess == .high ? "HIGH：自分のカードの方が強い" : "LOW：自分のカードの方が弱い")
    }
}
