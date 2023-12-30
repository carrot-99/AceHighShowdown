//  Player.swift

import Foundation

class Player: ObservableObject {
    var hand: [Card]
    var name: String
    var cardsWon: Int = 0

    init(name: String) {
        self.name = name
        self.hand = []
    }

    func playCard() -> Card? {
        if hand.isEmpty {
            return nil
        } else {
            return hand.removeFirst()
        }
    }
    
    func winCards() {
        self.cardsWon += 2
    }
    
    // プレイヤーの手札と勝ったカードの数をリセットする
    func reset() {
        hand.removeAll()
        cardsWon = 0
    }
}
