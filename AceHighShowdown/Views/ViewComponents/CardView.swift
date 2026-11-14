//  CardView.swift

import SwiftUI

/// 表裏をめくるアニメーション付きのカード
struct CardView: View {
    let card: Card
    let isFaceUp: Bool

    var body: some View {
        FlipView(rotation: isFaceUp ? 0 : 180) {
            CardImage(name: card.imageName)
        } back: {
            CardImage(name: "CardDesign")
        }
        .animation(.easeInOut(duration: 0.45), value: isFaceUp)
        .accessibilityElement()
        .accessibilityLabel(isFaceUp ? card.shortName : "裏向きのカード")
    }
}

/// カードの裏面（山札表示用）
struct CardBackView: View {
    var body: some View {
        CardImage(name: "CardDesign")
    }
}

/// カードがない場所のプレースホルダー
struct EmptyCardSlot: View {
    var body: some View {
        RoundedRectangle(cornerRadius: Theme.cardCornerRadius)
            .strokeBorder(Color.white.opacity(0.35), style: StrokeStyle(lineWidth: 2, dash: [6]))
            .aspectRatio(1 / Theme.cardAspectRatio, contentMode: .fit)
    }
}

/// 残り枚数に応じて重なって見える山札
struct DeckStackView: View {
    let count: Int

    var body: some View {
        ZStack {
            if count == 0 {
                EmptyCardSlot()
            } else {
                ForEach(0..<min(count, 3), id: \.self) { index in
                    CardBackView()
                        .offset(x: CGFloat(index) * 2, y: CGFloat(index) * -2)
                }
            }
        }
        .accessibilityElement()
        .accessibilityLabel("山札 残り\(count)枚")
    }
}

private struct CardImage: View {
    let name: String

    var body: some View {
        Image(name)
            .resizable()
            .aspectRatio(1 / Theme.cardAspectRatio, contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: Theme.cardCornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: Theme.cardCornerRadius)
                    .stroke(Color.black.opacity(0.4), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.35), radius: 3, x: 1, y: 2)
    }
}

/// Y軸回転で表裏を切り替える。回転の途中（90°）で表示面を入れ替えるので、裏から表が透けない
private struct FlipView<Front: View, Back: View>: View, Animatable {
    var rotation: Double
    let front: Front
    let back: Back

    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }

    init(rotation: Double, @ViewBuilder front: () -> Front, @ViewBuilder back: () -> Back) {
        self.rotation = rotation
        self.front = front()
        self.back = back()
    }

    var body: some View {
        ZStack {
            if rotation < 90 {
                front
            } else {
                back.rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
            }
        }
        .rotation3DEffect(.degrees(rotation), axis: (x: 0, y: 1, z: 0), perspective: 0.4)
    }
}
