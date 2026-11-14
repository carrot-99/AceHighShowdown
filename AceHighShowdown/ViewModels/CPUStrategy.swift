//  CPUStrategy.swift

import Foundation

enum Difficulty: String, CaseIterable, Identifiable {
    case easy = "Easy"
    case normal = "Normal"
    case hard = "Hard"

    var id: String { rawValue }

    var title: String { rawValue.uppercased() }

    var description: String {
        switch self {
        case .easy: return "CPUは気まぐれに予想します"
        case .normal: return "CPUは場のカードを見て予想します"
        case .hard: return "CPUは出たカードをすべて覚えています"
        }
    }

    var iconName: String {
        switch self {
        case .easy: return "tortoise.fill"
        case .normal: return "figure.walk"
        case .hard: return "brain.head.profile"
        }
    }
}

/// CPUの HIGH / LOW 判断ロジック
struct CPUStrategy {
    let difficulty: Difficulty

    /// - Parameters:
    ///   - opponentCard: 表向きになっている相手（ユーザー）のカード
    ///   - knownCards: これまでに公開されたカード（`opponentCard` は含まなくてよい）
    func guess(against opponentCard: Card, knownCards: Set<Card>) -> Guess {
        switch difficulty {
        case .easy:
            return Bool.random() ? .high : .low
        case .normal:
            // 相手のランクが低いほど HIGH を選びやすい（A: 80% 〜 K: 20%）
            let highProbability = 0.8 - Double(opponentCard.rank.rawValue - 1) * 0.05
            return Double.random(in: 0..<1) < highProbability ? .high : .low
        case .hard:
            // 未公開カードを数え、勝てる可能性が高い方を選ぶ（カウンティング）
            let unknown = Card.allCards.filter { $0 != opponentCard && !knownCards.contains($0) }
            let higher = unknown.filter { $0 > opponentCard }.count
            let lower = unknown.count - higher
            if higher == lower { return Bool.random() ? .high : .low }
            return higher > lower ? .high : .low
        }
    }
}
