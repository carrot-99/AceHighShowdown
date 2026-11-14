//  RecordStore.swift

import Foundation

enum GameOutcome {
    case win, loss, draw
}

struct DifficultyRecord {
    var wins = 0
    var losses = 0
    var draws = 0
    var bestScore = 0
    var bestStreak = 0

    var total: Int { wins + losses + draws }

    /// 勝率（0.0〜1.0）。対戦がない場合は nil
    var winRate: Double? {
        total == 0 ? nil : Double(wins) / Double(total)
    }
}

/// 難易度別の戦績を UserDefaults に保存する
/// キー名は旧バージョン（winsEasy など）と互換
struct RecordStore {
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func record(for difficulty: Difficulty) -> DifficultyRecord {
        let d = difficulty.rawValue
        return DifficultyRecord(
            wins: defaults.integer(forKey: "wins\(d)"),
            losses: defaults.integer(forKey: "losses\(d)"),
            draws: defaults.integer(forKey: "draws\(d)"),
            bestScore: defaults.integer(forKey: "bestScore\(d)"),
            bestStreak: defaults.integer(forKey: "bestStreak\(d)")
        )
    }

    func save(outcome: GameOutcome, score: Int, bestStreak: Int, difficulty: Difficulty) {
        let d = difficulty.rawValue
        let key: String
        switch outcome {
        case .win: key = "wins\(d)"
        case .loss: key = "losses\(d)"
        case .draw: key = "draws\(d)"
        }
        defaults.set(defaults.integer(forKey: key) + 1, forKey: key)

        let current = record(for: difficulty)
        if score > current.bestScore { defaults.set(score, forKey: "bestScore\(d)") }
        if bestStreak > current.bestStreak { defaults.set(bestStreak, forKey: "bestStreak\(d)") }
    }

    func resetAll() {
        for difficulty in Difficulty.allCases {
            let d = difficulty.rawValue
            for prefix in ["wins", "losses", "draws", "bestScore", "bestStreak"] {
                defaults.removeObject(forKey: "\(prefix)\(d)")
            }
        }
    }
}

enum StorageKeys {
    static let hasAgreedToTerms = "hasAgreedToTerms"
    static let hapticsEnabled = "hapticsEnabled"
}
