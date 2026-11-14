//  AdManager.swift

import UIKit
import GoogleMobileAds
import AppTrackingTransparency

enum AdConfig {
    static var bannerUnitID: String? { value(for: "AdBannerUnitID") }
    static var interstitialUnitID: String? { value(for: "AdInterstitialUnitID") }

    private static func value(for key: String) -> String? {
        guard let id = Bundle.main.object(forInfoDictionaryKey: key) as? String, !id.isEmpty else {
            assertionFailure("\(key) not found in Info.plist")
            return nil
        }
        return id
    }
}

/// インタースティシャル広告の読み込みと表示を担当する
final class InterstitialAdManager {
    private var interstitial: GADInterstitialAd?
    private var isLoading = false

    func load() {
        guard interstitial == nil, !isLoading, let unitID = AdConfig.interstitialUnitID else { return }
        isLoading = true
        GADInterstitialAd.load(withAdUnitID: unitID, request: GADRequest()) { [weak self] ad, error in
            self?.isLoading = false
            if let error = error {
                print("Failed to load interstitial ad: \(error.localizedDescription)")
                return
            }
            self?.interstitial = ad
        }
    }

    /// 広告が準備できていれば表示し、次回用に再読み込みする
    func showIfReady() {
        guard let ad = interstitial, let root = UIApplication.shared.topViewController else {
            load()
            return
        }
        interstitial = nil
        ad.present(fromRootViewController: root)
        load()
    }
}

enum TrackingPermission {
    /// 未確認の場合のみ App Tracking Transparency の許可ダイアログを表示する
    static func requestIfNeeded() {
        guard ATTrackingManager.trackingAuthorizationStatus == .notDetermined else { return }
        // 画面遷移直後だとダイアログが表示されないことがあるため少し待つ
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ATTrackingManager.requestTrackingAuthorization { _ in }
        }
    }
}

extension UIApplication {
    var activeKeyWindow: UIWindow? {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first(where: \.isKeyWindow)
    }

    /// 最前面に表示されている ViewController
    var topViewController: UIViewController? {
        var top = activeKeyWindow?.rootViewController
        while let presented = top?.presentedViewController {
            top = presented
        }
        return top
    }
}
