// GameView.swift

import SwiftUI

struct GameView: View {
    @ObservedObject var viewModel: GameViewModel
    @Binding var isGameActive: Bool
    @State private var gameStarted = false
    @State private var showResult = false
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("EmptyCard")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                
                VStack(spacing: 10) {
                    GameStatusBarView(gameStatus: $viewModel.gameStatus, playerChoice: $viewModel.playerChoice)
                    
                    Spacer()
                    
                    // CPU関連のビュー
                    HStack {
                        if gameStarted {
                            ScoreView(playerName: viewModel.cpuPlayer.name, cardsRemaining: viewModel.cpuPlayer.hand.count, score: viewModel.cpuPlayer.cardsWon)
                            Spacer()
                            if let cpuCard = viewModel.cpuCard {
                                CardView(card: cpuCard)
                                    .frame(width: cardWidth(in: geometry), height: cardWidth(in: geometry) * 1.4)
                            }
                            deckView(for: viewModel.cpuPlayer, width: cardWidth(in: geometry))
                        }
                    }
                    
                    Spacer()
                    
                    if let result = viewModel.result {
                        ChoiceResultView(result: result)
                    }
                    
                    Spacer()
                    
                    // ユーザ関連のビュー
                    HStack {
                        if gameStarted {
                            deckView(for: viewModel.currentPlayer, width: cardWidth(in: geometry))
                            
                            if let playerCard = viewModel.currentCard {
                                CardView(card: playerCard)
                                    .frame(width: cardWidth(in: geometry), height: cardWidth(in: geometry) * 1.4)
                            }
                            Spacer()
                            ScoreView(playerName: viewModel.currentPlayer.name, cardsRemaining: viewModel.currentPlayer.hand.count, score: viewModel.currentPlayer.cardsWon)
                        }
                    }
                    
                    Spacer()
                    
                    // ゲームアクションボタン
                    gameActionButton.frame(height: 60)
                }
                .padding(.horizontal)
                .padding(.bottom, 60)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }

    var gameActionButton: some View {
        GeometryReader { geometry in
            Group {
                HStack {
                    Spacer()
                    
                    if !gameStarted {
                        Button(action: {
                            gameStarted = true
                            viewModel.startGame()
                            if !viewModel.isPlayerTurn {
                                viewModel.playCpuTurn()
                                viewModel.gameStatus = "CPUの番"
                            } else {
                                viewModel.gameStatus = "あなたの番"
                            }
                        }) {
                            Text("ゲームスタート")
                                .frame(width: geometry.size.width * 0.8)
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.green)
                                .cornerRadius(10)
                        }
                        .contentShape(Rectangle())
                    } else if !viewModel.isPlayerTurn && !showResult {
                        Button(action: {
                            viewModel.judgeCpuTurn()
                            showResult = true
                        }) {
                            Text("オープン")
                                .frame(width: geometry.size.width * 0.8)
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .contentShape(Rectangle())
                    } else if viewModel.isPlayerTurn && !showResult {
                        HStack {
                            Button(action: {
                                viewModel.guessHigh()
                                showResult = true
                            }) {
                                Text("HIGH")
                                    .frame(width: geometry.size.width * 0.4)
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }
                            .contentShape(Rectangle())

                            Button(action: {
                                viewModel.guessLow()
                                showResult = true
                            }) {
                                Text("LOW")
                                    .frame(width: geometry.size.width * 0.4)
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }
                            .contentShape(Rectangle())
                        }
                    } else if viewModel.currentPlayer.hand.count == 0 {
                        NavigationLink(destination: ResultView(viewModel: viewModel, userScore: viewModel.currentPlayer.cardsWon, cpuScore: viewModel.cpuPlayer.cardsWon, isGameActive: $isGameActive)) {
                            Text("最終結果を見る")
                                .frame(width: geometry.size.width * 0.8)
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .contentShape(Rectangle())
                        .simultaneousGesture(TapGesture().onEnded {
                            showInterstitialAd()
                        })
                    } else {
                        Button(action: {
                            viewModel.changeTurn()
                            viewModel.dealInitialCards()
                            if !viewModel.isPlayerTurn {
                                viewModel.playCpuTurn()
                            }
                            showResult = false
                        }) {
                            Text("次のターン")
                                .frame(width: geometry.size.width * 0.8)
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .contentShape(Rectangle())
                    }
                    
                    Spacer()
                }
            }
        }
    }
    
    func deckView(for player: Player, width: CGFloat) -> some View {
        let cardCount = player.hand.count
        let displayCount = min(cardCount, 3)
        
        return Group {
            if cardCount == 0 {
                EmptyCardView()
                    .frame(width: width, height: width * 1.4)
            } else {
                ZStack {
                    ForEach(0..<displayCount, id: \.self) { index in
                        CardBackView()
                            .frame(width: width, height: width * 1.4)
                            .offset(x: CGFloat(index * 2), y: CGFloat(index * 2))
                    }
                }
            }
        }
    }
    
    struct CardBackView: View {
        var body: some View {
            ZStack {
                Image("CardDesign")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black, lineWidth: 1)
            )
        }
    }
    
    struct EmptyCardView: View {
        var body: some View {
            ZStack {
                Image("EmptyCard")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black, lineWidth: 1)
            )
        }
    }
    
    // カードの幅を計算するメソッド
    private func cardWidth(in geometry: GeometryProxy) -> CGFloat {
        // iPadの場合
        if horizontalSizeClass == .regular && verticalSizeClass == .regular {
            // iPadの画面サイズに応じたカードの幅を計算
            return min(geometry.size.width, geometry.size.height) * 0.15
        } else {
            // iPhoneの場合は画面の20%をカードの幅とする
            return geometry.size.width * 0.2
        }
    }
    
    func showInterstitialAd() {
        if let controller = topMostViewController() {
            viewModel.showInterstitialAd(from: controller)
        }
    }
    
    func topMostViewController() -> UIViewController? {
        // アプリケーションのキーウィンドウのrootViewControllerを取得
        guard let rootController = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController else {
            return nil
        }
        // 最前面のViewControllerを取得するための補助関数
        func getTopMostViewController(from viewController: UIViewController) -> UIViewController {
            // presentedViewControllerがある場合は、それをフォローする
            if let presented = viewController.presentedViewController {
                return getTopMostViewController(from: presented)
            }
            // UINavigationControllerの場合は、最後のViewControllerを参照する
            else if let navigationController = viewController as? UINavigationController, let lastViewController = navigationController.viewControllers.last {
                return getTopMostViewController(from: lastViewController)
            }
            // UITabBarControllerの場合は、選択されているViewControllerを参照する
            else if let tabBarController = viewController as? UITabBarController, let selectedViewController = tabBarController.selectedViewController {
                return getTopMostViewController(from: selectedViewController)
            }
            // それ以外の場合は、自身を返す
            else {
                return viewController
            }
        }
        // 最前面のViewControllerを返す
        return getTopMostViewController(from: rootController)
    }
}

extension View {
    func topMostViewController() -> UIViewController? {
        var topController: UIViewController? = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
        while let presentedViewController = topController?.presentedViewController {
            topController = presentedViewController
        }
        return topController
    }
}
