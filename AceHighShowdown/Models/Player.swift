//  Player.swift

import Foundation

struct Player {
    let name: String
    var hand: [Card] = []
    var score: Int = 0

    /// 1ラウンドで勝利した際に獲得するポイント（場の2枚分）
    static let pointsPerWin = 2

    mutating func playCard() -> Card? {
        hand.isEmpty ? nil : hand.removeFirst()
    }

    mutating func winRound() {
        score += Self.pointsPerWin
    }
}
