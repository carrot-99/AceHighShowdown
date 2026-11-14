//  PlayedCardsView.swift

import SwiftUI

/// これまでに出たカードの一覧（カウンティング用）
struct PlayedCardsView: View {
    let knownCards: Set<Card>

    @Environment(\.dismiss) private var dismiss

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 13)

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("出たカード \(knownCards.count) / 52 枚")
                        .font(.headline)

                    ForEach(Suit.allCases.reversed(), id: \.self) { suit in
                        VStack(alignment: .leading, spacing: 6) {
                            Text("\(suit.symbol) \(suit.assetName)")
                                .font(.subheadline.bold())
                                .foregroundColor(suit.isRed ? .red : .primary)
                            LazyVGrid(columns: columns, spacing: 4) {
                                ForEach(Rank.allCases, id: \.self) { rank in
                                    cell(Card(rank: rank, suit: suit))
                                }
                            }
                        }
                    }

                    Label("グレーのカードは既に出たカードです。強さ：A（最弱）〜 K（最強）、同じ数字なら ♣ < ♦ < ♥ < ♠", systemImage: "info.circle")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                .padding()
            }
            .navigationTitle("出たカード")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("閉じる") { dismiss() }
                }
            }
        }
    }

    private func cell(_ card: Card) -> some View {
        let played = knownCards.contains(card)
        return Text(card.rank.displayName)
            .strikethrough(played)
            .font(.system(size: 13, weight: .bold, design: .rounded))
            .frame(maxWidth: .infinity, minHeight: 34)
            .foregroundColor(played ? .secondary : (card.suit.isRed ? .red : .primary))
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .fill(played ? Color.gray.opacity(0.25) : Color(.secondarySystemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.gray.opacity(played ? 0 : 0.4), lineWidth: 1)
            )
            .accessibilityLabel("\(card.shortName) \(played ? "出た" : "未出")")
    }
}
