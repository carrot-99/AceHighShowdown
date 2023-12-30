//  ContentView.swift

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = GameViewModel()
    @State private var isShowingTerms = true
    @State private var hasAgreedToTerms = UserDefaults.standard.bool(forKey: "hasAgreedToTerms")
    @State private var isGameActive = false
    
    init() {
        let viewModel = GameViewModel()
        _viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        if hasAgreedToTerms {
            if isGameActive {
                NavigationView {
                    GameView(viewModel: viewModel, isGameActive: $isGameActive)
                        .overlay(
                            VStack {
                                Spacer()
                                AdMobBannerView()
                                    .frame(width: UIScreen.main.bounds.width, height: 50)
                                    .background(Color.gray.opacity(0.1))
                            },
                            alignment: .bottom
                        )
                }
                .navigationViewStyle(StackNavigationViewStyle())
            } else {
                TitleView(isGameActive: $isGameActive, viewModel: viewModel)
                    .overlay(
                        VStack {
                            Spacer()
                            AdMobBannerView()
                                .frame(width: UIScreen.main.bounds.width, height: 50)
                                .background(Color.gray.opacity(0.1))
                        },
                        alignment: .bottom
                    )
            }
        } else {
            TermsAndPrivacyAgreementView(isShowingTerms: $isShowingTerms, hasAgreedToTerms: $hasAgreedToTerms)
        }
    }
}
