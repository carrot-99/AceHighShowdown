//  GameViewModel.swift

import Foundation
import SwiftUI
import GoogleMobileAds

class GameViewModel: ObservableObject {
    @Published private(set) var deck = Deck()
    @Published private(set) var currentPlayer: Player {
        didSet {
            updateCardsRemaining()
        }
    }
    @Published private(set) var cpuPlayer: Player {
        didSet {
            updateCardsRemaining()
        }
    }
    @Published var currentCard: Card?
    @Published var cpuCard: Card?
    @Published var gameStatus: String = ""
    @Published var isPlayerTurn: Bool = Bool.random()
    @Published var currentCardIsFaceUp: Bool = false
    @Published var cpuGuessHigh: Bool = false
    @Published var playerChoice: String?
    @Published var result: Bool?
    @Published private(set) var playedCards = Set<Card>()
    var difficulty: Difficulty = .normal
    private var interstitial: GADInterstitialAd?

    init() {
        self.currentPlayer = Player(name: "あなた")
        self.cpuPlayer = Player(name: "CPU")
        self.deck.shuffle()
        self.gameStatus = "ゲームを開始します"
        loadInterstitialAd()
    }
    
    // MARK: - 共通
    
    // ゲーム開始時の処理
    func startGame() {
        // デッキをシャッフル、両プレイヤーにカードを配る
        deck.shuffle()
        currentPlayer.hand = deck.dealHand(size: 26)
        cpuPlayer.hand = deck.dealHand(size: 26)
        // ターン決め
        isPlayerTurn = Bool.random()
        // 最初のカードを場に出す
        dealInitialCards()
    }
    
    // カードを場に出す
    func dealInitialCards() {
        if isPlayerTurn {
            // ユーザーのターンの場合
            currentCard = currentPlayer.playCard()
            currentCard?.isFaceUp = false
            cpuCard = cpuPlayer.playCard()
            cpuCard?.isFaceUp = true
        } else {
            // CPUのターンの場合
            cpuCard = cpuPlayer.playCard()
            cpuCard?.isFaceUp = false
            currentCard = currentPlayer.playCard()
            currentCard?.isFaceUp = true
        }
    }
    
    // ターン交代
    func changeTurn() {
        if isPlayerTurn {
            isPlayerTurn = false
            gameStatus = "CPUの番"
        } else {
            isPlayerTurn = true
            gameStatus = "あなたの番"
        }
        if let card = currentCard {
             playedCards.insert(card)
         }
         if let card = cpuCard {
             playedCards.insert(card)
         }
        playerChoice = nil
        result = nil
    }
    
    // 残りカード枚数の計算
    private func updateCardsRemaining() {
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }

    // カードを表向きにする
    private func flipCard() {
        if isPlayerTurn {
            currentCardIsFaceUp = true
            currentCard?.isFaceUp = true
        } else {
            cpuCard?.isFaceUp = true
        }
    }
    
    // ゲームのリセット
    func resetGame() {
        // デッキをリセット
        deck.reset()
        deck.shuffle()
        // プレイヤーの手札と勝ちカードをクリア
        currentPlayer.reset()
        cpuPlayer.reset()
        // カードの状態をリセット
        currentCard = nil
        cpuCard = nil
        // ゲームの状態をリセット
        gameStatus = "ゲームを開始します"
        isPlayerTurn = Bool.random()
        currentCardIsFaceUp = false
        cpuGuessHigh = false
        playerChoice = nil
        result = nil
        // プレイ済みのカードをクリア
        playedCards.removeAll()
        // 広告を再ロード
        loadInterstitialAd()
    }
    
    // MARK: - ユーザ用
    
    // "HIGH" 選択時の処理
    func guessHigh() {
        guard let humanCard = currentCard, let cpuCard = cpuCard else { return }
        playerChoice = "HIGH"
        flipCard()

        if humanCard.rank.rawValue > cpuCard.rank.rawValue ||
           (humanCard.rank == cpuCard.rank && humanCard.suit > cpuCard.suit) {
            result = true
            currentPlayer.winCards()
        } else {
            result = false
        }
    }

    // "LOW" 選択時の処理
    func guessLow() {
        guard let humanCard = currentCard, let cpuCard = cpuCard else { return }
        playerChoice = "LOW"
        flipCard()

        if humanCard.rank < cpuCard.rank ||
           (humanCard.rank == cpuCard.rank && humanCard.suit < cpuCard.suit) {
            result = true
            currentPlayer.winCards()
        } else {
            result = false
        }
    }
    
    // 戦績の更新
    func updateRecords() {
        let defaults = UserDefaults.standard
        let resultKey: String
        let difficultyKeyPrefix: String
        let userScore = currentPlayer.cardsWon
        let cpuScore = cpuPlayer.cardsWon
        
        // 難易度に基づいたキー接頭辞を決定
        switch difficulty {
        case .easy:
            difficultyKeyPrefix = "Easy"
        case .normal:
            difficultyKeyPrefix = "Normal"
        case .hard:
            difficultyKeyPrefix = "Hard"
        }
        
        // 勝敗に基づいたキーを決定
        if userScore > cpuScore {
            resultKey = "wins\(difficultyKeyPrefix)"
        } else if userScore < cpuScore {
            resultKey = "losses\(difficultyKeyPrefix)"
        } else {
            resultKey = "draws\(difficultyKeyPrefix)"
        }
        
        // 戦績を更新
        let currentCount = defaults.integer(forKey: resultKey)
        defaults.set(currentCount + 1, forKey: resultKey)
    }

    
    // MARK: - CPU用
    
    // CPUがターンをプレイする
    func playCpuTurn() {
        cpuGuessHigh = makeCpuGuess()
        playerChoice = cpuGuessHigh ? "HIGH" : "LOW"
    }
    
    // 難易度別のロジック
    private func makeCpuGuess() -> Bool {
        switch difficulty {
        case .easy:
            // 簡単な難易度では完全にランダム
            return Bool.random()
        case .normal:
            // 普通の難易度では、場のカードを考慮するなどの簡単なロジック
            return guessWithSomeLogic()
        case .hard:
            // 難しい難易度では、より複雑なロジックや過去のターンから学習する
            return guessWithAdvancedLogic()
        }
    }
    
    // 普通の難易度のロジック
    private func guessWithSomeLogic() -> Bool {
        // ランクごとに確率調整
        let probabilities: [Rank: Double] = [
            .ace: 0.8,
            .two: 0.75,
            .three: 0.7,
            .four: 0.65,
            .five: 0.6,
            .six: 0.55,
            .seven: 0.5,
            .eight: 0.45,
            .nine: 0.4,
            .ten: 0.35,
            .jack: 0.3,
            .queen: 0.25,
            .king: 0.2
        ]
        // ユーザーの場のカード（currentCard）のランクを取得
        if let currentRank = currentCard?.rank {
            // 確率を取得（デフォルトは0.5）
            let probability = probabilities[currentRank] ?? 0.5

            // 乱数を生成して確率によりハイかローを決定
            return Double.random(in: 0...1) < probability
        }
        
        return Bool.random()
    }
    
    // 難しい難易度のロジック
    private func guessWithAdvancedLogic() -> Bool {
        guard let currentCard = currentCard else { return Bool.random() }
        let remainingHighCards = calculateRemainingHighCards(for: currentCard)
        let totalRemainingCards = 52 - playedCards.count
        let highCardProbability = Double(remainingHighCards) / Double(totalRemainingCards)

        // ハイカードの確率が50%より高い場合、trueを返す
        return Double.random(in: 0...1) < highCardProbability
    }

    // 残りのハイカードの数を計算
    private func calculateRemainingHighCards(for currentCard: Card) -> Int {
        let totalHigh = (13 - currentCard.rank.value) * 4 + currentCard.suit.index
        let alreadyPlayedHigh = playedCards.filter { card in
            card.rank > currentCard.rank || (card.rank == currentCard.rank && card.suit > currentCard.suit)
        }.count
        return totalHigh - alreadyPlayedHigh
    }
    
    // CPUのターンの結果
    func judgeCpuTurn() {
        guard let humanCard = currentCard else { return }

        flipCard()

        if cpuGuessHigh {
            if cpuCard!.rank.rawValue > humanCard.rank.rawValue || (cpuCard!.rank == humanCard.rank && cpuCard!.suit > humanCard.suit) {
                result = true
                cpuPlayer.winCards()
            } else {
                result = false
            }
        } else {
            if cpuCard!.rank < humanCard.rank || (cpuCard!.rank == humanCard.rank && cpuCard!.suit < humanCard.suit) {
                result = true
                cpuPlayer.winCards()
            } else {
                result = false
            }
        }
    }
    
    // MARK: - 広告
    // インタースティシャル広告をロードする
    func loadInterstitialAd() {
        let adUnitID: String
        if let adUnitIDFromPlist = Bundle.main.infoDictionary?["AdInterstitialUnitID"] as? String {
            adUnitID = adUnitIDFromPlist
        } else {
            fatalError("AdUnitID not found in Info.plist")
        }
        
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: adUnitID, request: request) { [weak self] ad, error in
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            self?.interstitial = ad
        }
    }

    // インタースティシャル広告を表示する
    func showInterstitialAd(from root: UIViewController) {
        if let interstitial = interstitial {
            interstitial.present(fromRootViewController: root)
        } else {
            print("Ad wasn't ready")
            loadInterstitialAd()  // 広告がなかった場合、再度ロードを試みる
        }
    }
}

enum Difficulty {
    case easy, normal, hard
}
