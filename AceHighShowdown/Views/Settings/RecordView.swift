//  RecordView.swift

import SwiftUI

struct RecordView: View {
    @State private var records: [(Difficulty, DifficultyRecord)] = []

    var body: some View {
        List {
            ForEach(records, id: \.0) { difficulty, record in
                Section(difficulty.title) {
                    if record.total == 0 {
                        Text("まだ対戦していません")
                            .foregroundColor(.secondary)
                    } else {
                        HStack {
                            statColumn("勝利", record.wins, color: .green)
                            statColumn("敗北", record.losses, color: .red)
                            statColumn("引き分け", record.draws, color: .secondary)
                        }
                        row("勝率", record.winRate.map { String(format: "%.1f%%", $0 * 100) } ?? "-")
                        row("対戦数", "\(record.total)")
                        row("最高スコア", "\(record.bestScore)")
                        row("最大連続正解", "\(record.bestStreak)")
                    }
                }
            }
        }
        .navigationTitle("戦績")
        .onAppear {
            let store = RecordStore()
            records = Difficulty.allCases.map { ($0, store.record(for: $0)) }
        }
    }

    private func statColumn(_ title: String, _ value: Int, color: Color) -> some View {
        VStack(spacing: 2) {
            Text("\(value)")
                .font(.title2.bold().monospacedDigit())
                .foregroundColor(color)
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
    }

    private func row(_ title: String, _ value: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .monospacedDigit()
                .foregroundColor(.secondary)
        }
    }
}
