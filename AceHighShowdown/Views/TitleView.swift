//  TitleView.swift

import SwiftUI

struct TitleView: View {
    @ObservedObject var viewModel: GameViewModel
    @State private var showingDifficultySelection = false
    @State private var showingHowToPlay = false
    @State private var showingSettings = false

    var body: some View {
        ZStack {
            FeltBackground()

            VStack(spacing: 32) {
                Spacer()

                CardFanView()
                    .frame(height: 160)

                VStack(spacing: 4) {
                    Text("ACE HIGH")
                    Text("SHOWDOWN")
                }
                .font(.system(size: 44, weight: .heavy, design: .rounded))
                .foregroundStyle(LinearGradient(colors: [.white, Theme.gold], startPoint: .top, endPoint: .bottom))
                .shadow(color: .black.opacity(0.5), radius: 6, y: 4)
                .minimumScaleFactor(0.6)
                .lineLimit(1)
                .accessibilityElement(children: .combine)
                .accessibilityAddTraits(.isHeader)

                Spacer()

                VStack(spacing: 14) {
                    Button {
                        Haptics.tap()
                        showingDifficultySelection = true
                    } label: {
                        Label("CPUと対戦", systemImage: "play.fill")
                    }
                    .buttonStyle(.primaryGame)

                    HStack(spacing: 14) {
                        Button {
                            showingHowToPlay = true
                        } label: {
                            Label("遊び方", systemImage: "questionmark.circle")
                        }
                        Button {
                            showingSettings = true
                        } label: {
                            Label("設定", systemImage: "gearshape")
                        }
                    }
                    .buttonStyle(GameButtonStyle(background: Color.white.opacity(0.15)))
                }
                .frame(maxWidth: 420)
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
        .sheet(isPresented: $showingDifficultySelection) {
            DifficultySelectionView { difficulty in
                showingDifficultySelection = false
                viewModel.startGame(difficulty: difficulty)
            }
        }
        .sheet(isPresented: $showingHowToPlay) {
            HowToPlayView()
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
    }
}

/// タイトル画面の装飾用カード
private struct CardFanView: View {
    private let cards = ["ClubsA", "DiamondsA", "HeartsA", "SpadesA"]

    var body: some View {
        ZStack {
            ForEach(Array(cards.enumerated()), id: \.offset) { index, name in
                let angle = Double(index) * 12 - 18
                Image(name)
                    .resizable()
                    .aspectRatio(1 / Theme.cardAspectRatio, contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.cardCornerRadius))
                    .shadow(color: .black.opacity(0.4), radius: 4, x: 2, y: 3)
                    .rotationEffect(.degrees(angle), anchor: .bottom)
                    .offset(x: CGFloat(index) * 16 - 24)
            }
        }
        .accessibilityHidden(true)
    }
}

struct HowToPlayView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            List {
                Section("ルール") {
                    rule("rectangle.on.rectangle", "52枚のカードを26枚ずつ配り、毎ラウンド1枚ずつ場に出します。")
                    rule("eye.slash", "自分の番では自分のカードが裏向き、相手のカードが表向きになります。")
                    rule("arrow.up.arrow.down", "自分のカードが相手より「HIGH（強い）」か「LOW（弱い）」かを予想します。")
                    rule("star.fill", "予想が当たると\(Player.pointsPerWin)ポイント獲得。番は毎ラウンド交代します。")
                    rule("flag.checkered", "\(GameViewModel.totalRounds)ラウンド終了時にポイントが多い方の勝ちです。")
                }
                Section("カードの強さ") {
                    rule("number", "A（最弱）< 2 < 3 … < 10 < J < Q < K（最強）")
                    rule("suit.spade.fill", "同じ数字の場合はスートで比較：♣ < ♦ < ♥ < ♠")
                }
                Section("ヒント") {
                    rule("square.grid.3x3", "ゲーム中は右上のボタンから「出たカード」を確認できます。残りのカードを考えて予想しましょう。")
                }
            }
            .navigationTitle("遊び方")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("閉じる") { dismiss() }
                }
            }
        }
    }

    private func rule(_ icon: String, _ text: String) -> some View {
        Label {
            Text(text)
        } icon: {
            Image(systemName: icon).foregroundColor(.accentColor)
        }
        .padding(.vertical, 2)
    }
}
