//  SettingsView.swift

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var showingRecord = false
    @State private var showingTerms = false
    @State private var showingPrivacyPolicy = false

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section() {
                        Button("戦績") {
                            showingRecord = true
                        }
                        .sheet(isPresented: $showingRecord) {
                            RecordView()
                        }
                        
                        Button("利用規約") {
                            showingTerms = true
                        }
                        .sheet(isPresented: $showingTerms) {
                            TermsView()
                        }
                        
                        Button("プライバシーポリシー") {
                            showingPrivacyPolicy = true
                        }
                        .sheet(isPresented: $showingPrivacyPolicy) {
                            PrivacyPolicyView()
                        }
                    }
                }
                .navigationBarTitle("Settings")
                .navigationBarItems(trailing: Button("閉じる") {
                    presentationMode.wrappedValue.dismiss()
                })
            }
        }
    }
}
