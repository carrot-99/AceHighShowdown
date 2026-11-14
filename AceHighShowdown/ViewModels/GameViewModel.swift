//  GameViewModel.swift

import Foundation

@MainActor
final class GameViewModel: ObservableObject {
    enum Phase: Equatable {
        /// ゲーム開始前
        case notStarted
        /// ユーザーが HIGH / LOW を選ぶ番
        case playerGuessing
        /// CPU が予想済みで、カードのオープン待ち
        case cpuGuessed
        /// ラウンドの結果表示中
        case roundResult
        /// 全ラウンド終了
        case gameOver
    }

    static let handSize = 26
    static var totalRounds: Int { handSize }

    @Published private(set) var phase: Phase = .notStarted
    @Published private(set) var difficulty: Difficulty = .normal
    @Published private(set) var player = Player(name: "あなた")
    @Published private(set) var cpu = Player(name: "CPU")
    @Published private(set) var playerCard: Card?
    @Published private(set) var cpuCard: Card?
    @Published private(set) var isPlayerTurn = true
    @Published private(set) var guess: Guess?
    /// 予想した側が当たったかどうか（結果表示中のみ値を持つ）
    @Published private(set) var guessWasCorrect: Bool?
    @Published private(set) var round = 0
    /// 公開済み（勝負が終わった）カード
    @Published private(set) var knownCards = Set<Card>()
    /// ユーザーの連続正解数
    @Published private(set) var streak = 0
    @Published private(set) var bestStreak = 0

    private let recordStore: RecordStore
    private let adManager: InterstitialAdManager

    init(recordStore: RecordStore = RecordStore(), adManager: InterstitialAdManager = InterstitialAdManager()) {
        self.recordStore = recordStore
        self.adManager = adManager
    }

    // MARK: - 表示用

    var isRevealed: Bool { phase == .roundResult || phase == .gameOver }

    /// 自分の番のときは自分のカードが裏向き、相手の番のときは相手のカードが裏向き
    var isPlayerCardFaceUp: Bool { !isPlayerTurn || isRevealed }
    var isCpuCardFaceUp: Bool { isPlayerTurn || isRevealed }

    var isLastRound: Bool { player.hand.isEmpty && cpu.hand.isEmpty }

    var statusText: String {
        switch phase {
        case .notStarted: return "ゲームを開始します"
        case .playerGuessing: return "あなたの番：HIGH か LOW か？"
        case .cpuGuessed: return "CPUの番：予想が決まりました"
        case .roundResult:
            let guesser = isPlayerTurn ? "あなた" : "CPU"
            return guessWasCorrect == true ? "\(guesser)が \(Player.pointsPerWin) ポイント獲得！" : "\(guesser)の予想はハズレ"
        case .gameOver: return "ゲーム終了"
        }
    }

    var outcome: GameOutcome {
        if player.score > cpu.score { return .win }
        if player.score < cpu.score { return .loss }
        return .draw
    }

    // MARK: - ゲーム進行

    func startGame(difficulty: Difficulty) {
        self.difficulty = difficulty
        var deck = Deck()
        player = Player(name: player.name, hand: deck.deal(Self.handSize))
        cpu = Player(name: cpu.name, hand: deck.deal(Self.handSize))
        knownCards.removeAll()
        streak = 0
        bestStreak = 0
        round = 1
        isPlayerTurn = Bool.random()
        adManager.load()
        beginRound()
    }

    func restart() {
        startGame(difficulty: difficulty)
    }

    /// ゲームを途中でやめる（戦績には記録しない）
    func quit() {
        phase = .notStarted
    }

    /// ユーザーの予想
    func submitGuess(_ guess: Guess) {
        guard phase == .playerGuessing, let playerCard, let cpuCard else { return }
        self.guess = guess
        let correct = guess.isCorrect(card: playerCard, against: cpuCard)
        if correct {
            player.winRound()
            streak += 1
            bestStreak = max(bestStreak, streak)
        } else {
            streak = 0
        }
        reveal(correct: correct)
    }

    /// CPUの番でカードをオープンする
    func revealCpuCard() {
        guard phase == .cpuGuessed, let guess, let playerCard, let cpuCard else { return }
        let correct = guess.isCorrect(card: cpuCard, against: playerCard)
        if correct { cpu.winRound() }
        reveal(correct: correct)
    }

    func nextRound() {
        guard phase == .roundResult else { return }
        if isLastRound {
            finishGame()
        } else {
            round += 1
            isPlayerTurn.toggle()
            beginRound()
        }
    }

    // MARK: - Private

    private func beginRound() {
        playerCard = player.playCard()
        cpuCard = cpu.playCard()
        guess = nil
        guessWasCorrect = nil

        if isPlayerTurn {
            phase = .playerGuessing
        } else if let playerCard {
            guess = CPUStrategy(difficulty: difficulty).guess(against: playerCard, knownCards: knownCards)
            phase = .cpuGuessed
        }
    }

    private func reveal(correct: Bool) {
        guessWasCorrect = correct
        [playerCard, cpuCard].compactMap { $0 }.forEach { knownCards.insert($0) }
        phase = .roundResult
    }

    private func finishGame() {
        phase = .gameOver
        recordStore.save(outcome: outcome, score: player.score, bestStreak: bestStreak, difficulty: difficulty)
        adManager.showIfReady()
    }
}
