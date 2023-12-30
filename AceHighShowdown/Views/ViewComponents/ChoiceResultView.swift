//  ChoiceResultView.swift

import SwiftUI

struct ChoiceResultView: View {
    var result: Bool

    var body: some View {
        if result {
            VStack {
                Image(systemName: "checkmark")
                    .font(.largeTitle)
                Text("正解！")
                    .bold()
            }
            .foregroundColor(.green)
        } else {
            VStack {
                Image(systemName: "xmark")
                    .font(.largeTitle)
                Text("不正解")
                    .bold()
            }
            .foregroundColor(.red)
        }
    }
}
