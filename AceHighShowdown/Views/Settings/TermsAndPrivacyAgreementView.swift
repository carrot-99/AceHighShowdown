//  TermsAndPrivacyAgreementView.swift

import SwiftUI

struct TermsAndPrivacyAgreementView: View {
    @AppStorage(StorageKeys.hasAgreedToTerms) private var hasAgreedToTerms = false
    @State private var isShowingTermsView = false
    @State private var isShowingPrivacyPolicyView = false

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "suit.spade.fill")
                .font(.system(size: 56))
                .foregroundColor(.accentColor)

            Text("ACE HIGH SHOWDOWN")
                .font(.title.bold())

            Text("本アプリでは、お客様の体験を向上させるために広告を表示します。詳細については、以下の利用規約とプライバシーポリシーをご確認ください。")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            VStack(spacing: 12) {
                documentButton("利用規約", systemImage: "doc.text") { isShowingTermsView = true }
                documentButton("プライバシーポリシー", systemImage: "hand.raised") { isShowingPrivacyPolicyView = true }
            }

            Spacer()

            Button("NEXT") {
                hasAgreedToTerms = true
            }
            .buttonStyle(.primaryGame)
        }
        .padding(24)
        .frame(maxWidth: 520)
        .sheet(isPresented: $isShowingTermsView) {
            documentSheet("利用規約") { TermsView() }
        }
        .sheet(isPresented: $isShowingPrivacyPolicyView) {
            documentSheet("プライバシーポリシー") { PrivacyPolicyView() }
        }
    }

    private func documentButton(_ title: String, systemImage: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Label(title, systemImage: systemImage)
                Spacer()
                Image(systemName: "chevron.right").foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }

    private func documentSheet<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        NavigationView {
            content()
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("閉じる") {
                            isShowingTermsView = false
                            isShowingPrivacyPolicyView = false
                        }
                    }
                }
        }
    }
}
