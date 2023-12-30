//  PrivacyPolicyView.swift

import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Group {
                    Text("1. はじめに\n本プライバシーポリシーは、AceHighShowdown（以下「本アプリ」といいます）におけるユーザーのプライバシー保護と個人情報の取り扱いについて説明します。本アプリは個人情報の収集を行いませんが、広告配信のためにGoogle AdMobを利用しています。")
                        .padding(.bottom)
                    Text("2. 収集する情報\n本アプリでは、直接的にユーザーから個人情報を収集することはありません。ただし、AdMob広告サービスを通じて、非個人識別情報（匿名の利用データ、広告IDなど）が収集される場合があります。これによりユーザーの興味に基づいた広告が表示されることがあります。詳細についてはGoogleのプライバシーポリシーをご確認ください。")
                        .padding(.bottom)
                    Text("3. プライバシーポリシーの変更\n運営者は、必要に応じて本ポリシーを変更することがあります。変更があった場合は、本アプリ上または公式ウェブサイトで通知します。")
                        .padding(.bottom)
                    Text("4. お問い合わせ\n本プライバシーポリシーに関するお問い合わせやご不明点がある場合は、下記の運営者連絡先までお願いします。")
                        .padding(.bottom)
                }
                Group {
                    Text("運営者連絡先: carrot99.official@gmail.com")
                        .padding(.bottom)
                }
                
                Spacer()
                    .frame(height: 50)
            }
            .padding()
        }
        .navigationTitle("プライバシーポリシー")
    }
}
