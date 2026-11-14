//  Theme.swift

import SwiftUI
import UIKit

enum Theme {
    static let feltTop = Color(red: 0.05, green: 0.38, blue: 0.22)
    static let feltBottom = Color(red: 0.02, green: 0.20, blue: 0.12)
    static let gold = Color(red: 0.98, green: 0.80, blue: 0.30)
    static let high = Color(red: 0.20, green: 0.70, blue: 0.95)
    static let low = Color(red: 0.95, green: 0.40, blue: 0.40)

    static let primaryGradient = LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing)

    static func color(for guess: Guess) -> Color {
        guess == .high ? high : low
    }

    static let cardAspectRatio: CGFloat = 1.4
    static let cardCornerRadius: CGFloat = 8
}

/// トランプ台風のフェルト背景
struct FeltBackground: View {
    var body: some View {
        RadialGradient(colors: [Theme.feltTop, Theme.feltBottom], center: .center, startRadius: 50, endRadius: 600)
            .ignoresSafeArea()
    }
}

/// アプリ共通のボタンスタイル
struct GameButtonStyle<Background: ShapeStyle>: ButtonStyle {
    var background: Background
    var foreground: Color = .white

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(foreground)
            .frame(maxWidth: .infinity, minHeight: 52)
            .padding(.horizontal)
            .background(background, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            .shadow(color: .black.opacity(0.3), radius: 4, y: 2)
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .opacity(configuration.isPressed ? 0.85 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
            .contentShape(Rectangle())
    }
}

extension ButtonStyle where Self == GameButtonStyle<LinearGradient> {
    static var primaryGame: GameButtonStyle<LinearGradient> { GameButtonStyle(background: Theme.primaryGradient) }
}

/// 触覚フィードバック（設定でON/OFF可能）
enum Haptics {
    private static var isEnabled: Bool {
        UserDefaults.standard.object(forKey: StorageKeys.hapticsEnabled) as? Bool ?? true
    }

    static func tap() {
        guard isEnabled else { return }
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    static func notify(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        guard isEnabled else { return }
        UINotificationFeedbackGenerator().notificationOccurred(type)
    }
}
