//  Card.swift

import Foundation

enum Suit: String, CaseIterable {
    case clubs = "Clubs"
    case diamonds = "Diamonds"
    case hearts = "Hearts"
    case spades = "Spades"
    
    var index: Int {
        switch self {
        case .clubs:
            return 1
        case .diamonds:
            return 2
        case .hearts:
            return 3
        case .spades:
            return 4
        }
    }
}

enum Rank: Int, CaseIterable {
    case ace = 1
    case two = 2, three, four, five, six, seven, eight, nine, ten
    case jack = 11
    case queen = 12
    case king = 13
    
    var value: Int {
        return self.rawValue
    }
    
    var displayName: String {
        switch self {
        case .ace: return "A"
        case .jack: return "J"
        case .queen: return "Q"
        case .king: return "K"
        default: return String(self.rawValue)
        }
    }
}

struct Card: Identifiable, Hashable {
    var id = UUID()
    var rank: Rank
    var suit: Suit
    var isFaceUp: Bool = false
    
    var imageName: String {
        return "\(suit.rawValue)\(rank.displayName)"
    }

    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.rank == rhs.rank && lhs.suit == rhs.suit
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(rank)
        hasher.combine(suit)
    }
}

extension Rank: Comparable {
    static func < (lhs: Rank, rhs: Rank) -> Bool {
        switch (lhs, rhs) {
        case (.ace, .ace): return false  // A vs A: 同等
        case (.ace, _): return true     // A vs 他: A は常に弱い
        case (_, .ace): return false    // 他 vs A: A は常に弱い
        default: return lhs.rawValue < rhs.rawValue  // 他のカードの比較
        }
    }
    
    static func == (lhs: Rank, rhs: Rank) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

extension Suit: Comparable {
    static func < (lhs: Suit, rhs: Suit) -> Bool {
        return lhs.index < rhs.index
    }
    
    static func == (lhs: Suit, rhs: Suit) -> Bool {
        return lhs.index == rhs.index
    }
}
