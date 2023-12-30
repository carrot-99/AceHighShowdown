//  Deck.swift

import Foundation

struct Deck {
    var cards = [Card]()

    init() {
        for suit in [
            Suit.hearts,
            Suit.diamonds,
            Suit.clubs,
            Suit.spades
        ] {
            for rank in [
                Rank.ace,
                Rank.two,
                Rank.three,
                Rank.four,
                Rank.five,
                Rank.six,
                Rank.seven,
                Rank.eight,
                Rank.nine,
                Rank.ten,
                Rank.jack,
                Rank.queen,
                Rank.king
            ] {
                cards.append(Card(rank: rank, suit: suit))
            }
        }
    }

    mutating func shuffle() {
        cards.shuffle()
    }
    
    mutating func dealHand(size: Int) -> [Card] {
        var hand = [Card]()
        for _ in 0..<size {
            if let card = dealOne() {
                hand.append(card)
            }
        }
        return hand
    }

    mutating func dealOne() -> Card? {
        if cards.isEmpty {
            return nil
        } else {
            return cards.removeFirst()
        }
    }
    
    mutating func reset() {
        cards.removeAll()
        self = .init()
        shuffle()
    }
}
