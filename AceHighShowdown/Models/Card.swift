//  Card.swift

import Foundation

/// スートの強さは ♣ < ♦ < ♥ < ♠ の順
enum Suit: Int, CaseIterable, Comparable {
    case clubs = 1
    case diamonds
    case hearts
    case spades

    /// 画像アセット名に使うプレフィックス
    var assetName: String {
        switch self {
        case .clubs: return "Clubs"
        case .diamonds: return "Diamonds"
        case .hearts: return "Hearts"
        case .spades: return "Spades"
        }
    }

    var symbol: String {
        switch self {
        case .clubs: return "♣"
        case .diamonds: return "♦"
        case .hearts: return "♥"
        case .spades: return "♠"
        }
    }

    var isRed: Bool { self == .diamonds || self == .hearts }

    static func < (lhs: Suit, rhs: Suit) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

/// ランクの強さは A(最弱) < 2 < … < K(最強)
enum Rank: Int, CaseIterable, Comparable {
    case ace = 1
    case two, three, four, five, six, seven, eight, nine, ten
    case jack, queen, king

    var displayName: String {
        switch self {
        case .ace: return "A"
        case .jack: return "J"
        case .queen: return "Q"
        case .king: return "K"
        default: return String(rawValue)
        }
    }

    static func < (lhs: Rank, rhs: Rank) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

struct Card: Hashable, Identifiable, Comparable {
    let rank: Rank
    let suit: Suit

    var id: String { imageName }

    var imageName: String { "\(suit.assetName)\(rank.displayName)" }

    /// 例: "♠K"
    var shortName: String { "\(suit.symbol)\(rank.displayName)" }

    /// ランク → スートの順で比較する（同一カードは存在しないため引き分けはない）
    static func < (lhs: Card, rhs: Card) -> Bool {
        if lhs.rank != rhs.rank { return lhs.rank < rhs.rank }
        return lhs.suit < rhs.suit
    }

    /// 52枚すべてのカード
    static let allCards: [Card] = Suit.allCases.flatMap { suit in
        Rank.allCases.map { Card(rank: $0, suit: suit) }
    }
}

/// HIGH / LOW の予想
enum Guess: String {
    case high = "HIGH"
    case low = "LOW"

    /// `card` が `opponent` に対してこの予想どおりかどうか
    func isCorrect(card: Card, against opponent: Card) -> Bool {
        switch self {
        case .high: return card > opponent
        case .low: return card < opponent
        }
    }
}
