//  Deck.swift

import Foundation

struct Deck {
    private(set) var cards: [Card]

    /// シャッフル済みの52枚のデッキを作る
    init() {
        cards = Card.allCards.shuffled()
    }

    var isEmpty: Bool { cards.isEmpty }

    mutating func deal(_ count: Int) -> [Card] {
        let hand = Array(cards.prefix(count))
        cards.removeFirst(hand.count)
        return hand
    }
}
