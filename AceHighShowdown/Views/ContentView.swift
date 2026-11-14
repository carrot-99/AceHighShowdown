//  ContentView.swift

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GameViewModel()
    @AppStorage(StorageKeys.hasAgreedToTerms) private var hasAgreedToTerms = false

    var body: some View {
        Group {
            if !hasAgreedToTerms {
                TermsAndPrivacyAgreementView()
            } else {
                gameScreens
                    .bannerAd()
            }
        }
        .animation(.easeInOut(duration: 0.3), value: screenID)
    }

    @ViewBuilder
    private var gameScreens: some View {
        switch viewModel.phase {
        case .notStarted:
            TitleView(viewModel: viewModel)
                .onAppear(perform: TrackingPermission.requestIfNeeded)
                .transition(.opacity)
        case .gameOver:
            ResultView(viewModel: viewModel)
                .transition(.opacity)
        default:
            GameView(viewModel: viewModel)
                .transition(.opacity)
        }
    }

    /// 画面切り替えアニメーションのトリガー
    private var screenID: Int {
        guard hasAgreedToTerms else { return 0 }
        switch viewModel.phase {
        case .notStarted: return 1
        case .gameOver: return 3
        default: return 2
        }
    }
}
