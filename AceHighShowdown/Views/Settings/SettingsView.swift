//  SettingsView.swift

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage(StorageKeys.hapticsEnabled) private var hapticsEnabled = true
    @State private var showingResetConfirmation = false

    var body: some View {
        NavigationView {
            Form {
                Section("ゲーム") {
                    Toggle(isOn: $hapticsEnabled) {
                        Label("触覚フィードバック", systemImage: "iphone.radiowaves.left.and.right")
                    }
                }

                Section("戦績") {
                    NavigationLink {
                        RecordView()
                    } label: {
                        Label("戦績を見る", systemImage: "chart.bar.fill")
                    }
                    Button(role: .destructive) {
                        showingResetConfirmation = true
                    } label: {
                        Label("戦績をリセット", systemImage: "trash")
                    }
                }

                Section("情報") {
                    NavigationLink {
                        TermsView().navigationTitle("利用規約")
                    } label: {
                        Label("利用規約", systemImage: "doc.text")
                    }
                    NavigationLink {
                        PrivacyPolicyView().navigationTitle("プライバシーポリシー")
                    } label: {
                        Label("プライバシーポリシー", systemImage: "hand.raised")
                    }
                    HStack {
                        Label("バージョン", systemImage: "info.circle")
                        Spacer()
                        Text(appVersion).foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("設定")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("閉じる") { dismiss() }
                }
            }
            .confirmationDialog("すべての戦績をリセットしますか？", isPresented: $showingResetConfirmation, titleVisibility: .visible) {
                Button("リセット", role: .destructive) {
                    RecordStore().resetAll()
                    Haptics.notify(.warning)
                }
                Button("キャンセル", role: .cancel) {}
            } message: {
                Text("この操作は取り消せません。")
            }
        }
        .navigationViewStyle(.stack)
    }

    private var appVersion: String {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "-"
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "-"
        return "\(version) (\(build))"
    }
}
