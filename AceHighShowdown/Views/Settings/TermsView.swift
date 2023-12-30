//  TermsView.swift

import SwiftUI

struct TermsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Group {
                    Text("1. はじめに\n本利用規約（以下「本規約」といいます）は、AceHighShowdown（以下「本アプリ」といいます）の提供条件および運営者（以下「運営者」といいます）と本アプリのユーザー（以下「ユーザー」といいます）との間の権利義務関係を定めるものです。ユーザーは、本アプリを利用する前に、本規約をよく読み、その内容を理解し、同意した上で本アプリを利用してください。")
                        .padding(.bottom)
                    Text("2. サービスの利用\nユーザーは、本アプリを通じて、トランプゲーム「AceHighShowdown」を楽しむことができます。本アプリでは、ゲームの進行に関連する情報がアプリ内に保存されます。")
                        .padding(.bottom)
                    Text("3. 禁止事項\nユーザーは、法令または公序良俗に違反する行為、他のユーザーの体験を害する行為、運営者のサービス運営を妨害する行為などを行ってはなりません。また、本アプリの著作権を侵害する行為や不正な方法によるスコア操作も禁止されています。")
                        .padding(.bottom)
                }
                Group {
                    Text("4. 広告について\n本アプリは、AdMobバナー広告およびゲーム終了時に表示されるインタースティシャル広告を表示することにより収益を得ています。ユーザーは、アプリ利用中に表示される広告に関して、運営者は一切の責任を負わないことを承知してください。")
                        .padding(.bottom)
                    Text("5. 免責事項\n運営者は、本アプリに関して、その完全性、正確性、確実性等について一切保証しません。また、本アプリの利用により生じた損害について、運営者は責任を負わないものとします。ユーザーは自己の責任において本アプリを利用するものとします。")
                        .padding(.bottom)
                    Text("6. 規約の変更\n運営者は、必要と判断した場合には、ユーザーに通知することなく、本規約を変更することができます。変更後の規約に同意できない場合、ユーザーはサービスの利用を中止する権利があります。")
                        .padding(.bottom)
                }
                Group {
                    Text("7. 連絡先\n本アプリに関するお問い合わせは、運営者の公式メールアドレスまでお願いします。")
                        .padding(.bottom)
                }
                
                Spacer()
                    .frame(height: 50)
            }
            .padding()
        }
        .navigationTitle("利用規約")
    }
}