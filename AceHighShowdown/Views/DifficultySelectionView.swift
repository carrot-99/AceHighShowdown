//  DifficultySelectionView.swift

import SwiftUI

struct DifficultySelectionView: View {
    let onSelect: (Difficulty) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var records: [Difficulty: DifficultyRecord] = [:]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 14) {
                    ForEach(Difficulty.allCases) { difficulty in
                        Button {
                            Haptics.tap()
                            onSelect(difficulty)
                        } label: {
                            DifficultyRow(difficulty: difficulty, record: records[difficulty])
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .navigationTitle("難易度を選択")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") { dismiss() }
                }
            }
        }
        .onAppear {
            let store = RecordStore()
            records = Dictionary(uniqueKeysWithValues: Difficulty.allCases.map { ($0, store.record(for: $0)) })
        }
    }
}

private struct DifficultyRow: View {
    let difficulty: Difficulty
    let record: DifficultyRecord?

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: difficulty.iconName)
                .font(.title2)
                .frame(width: 44, height: 44)
                .background(Color.white.opacity(0.2), in: Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(difficulty.title)
                    .font(.headline)
                Text(difficulty.description)
                    .font(.subheadline)
                    .opacity(0.9)
                if let record, record.total > 0 {
                    Text("\(record.wins)勝 \(record.losses)敗 \(record.draws)分")
                        .font(.caption.monospacedDigit())
                        .opacity(0.8)
                }
            }
            Spacer()
            Image(systemName: "chevron.right")
                .opacity(0.7)
        }
        .foregroundColor(.white)
        .padding()
        .background(gradient, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .contentShape(Rectangle())
    }

    private var gradient: LinearGradient {
        let colors: [Color]
        switch difficulty {
        case .easy: colors = [.green, .teal]
        case .normal: colors = [.blue, .purple]
        case .hard: colors = [.orange, .red]
        }
        return LinearGradient(colors: colors, startPoint: .leading, endPoint: .trailing)
    }
}
