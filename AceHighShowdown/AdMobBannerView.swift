//  AdMobBannerView.swift

import SwiftUI
import GoogleMobileAds

struct AdMobBannerView: UIViewRepresentable {
    func makeUIView(context: Context) -> GADBannerView {
        let width = UIApplication.shared.activeKeyWindow?.bounds.width ?? UIScreen.main.bounds.width
        let banner = GADBannerView(adSize: GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(width))
        guard let unitID = AdConfig.bannerUnitID else { return banner }

        banner.adUnitID = unitID
        banner.rootViewController = UIApplication.shared.topViewController
        banner.load(GADRequest())
        return banner
    }

    func updateUIView(_ uiView: GADBannerView, context: Context) {}
}

extension View {
    /// 画面下部にバナー広告を表示する（コンテンツと重ならないよう safe area として確保）
    func bannerAd() -> some View {
        safeAreaInset(edge: .bottom, spacing: 0) {
            AdMobBannerView()
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial)
        }
    }
}
