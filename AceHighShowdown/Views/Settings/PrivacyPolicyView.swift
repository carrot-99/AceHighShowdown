//  PrivacyPolicyView.swift

import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Group {
                    Text("1. はじめに\n本プライバシーポリシーは、AceHighShowdownにおけるユーザーのプライバシー保護と個人情報の取り扱いについて説明します。本アプリは個人情報の収集を行わず、ユーザーのプライバシーを尊重します。")
                        .padding(.bottom)
                    Text("2. 広告とトラッキングについて\n本アプリでは、AdMob広告サービスを利用しています。AdMobは非個人識別情報を使用して広告を提供し、興味に基づいた広告を表示することがあります。ユーザーはiOSの設定からApp Tracking Transparencyを通じて、トラッキングの許可を管理することができます。")
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
