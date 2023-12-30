//  PlayerViewModel.swift

import Foundation

class PlayerViewModel: ObservableObject {
    @Published private(set) var player: Player
    var cards: [Card] {
        return player.hand
    }
    
    var name: String {
        return player.name
    }
    
    init(player: Player) {
        self.player = player
    }
    
    func playCard() -> Card? {
        return player.playCard()
    }
}
