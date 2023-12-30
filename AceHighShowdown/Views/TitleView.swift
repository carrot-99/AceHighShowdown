//  TitleView.swift

import SwiftUI

struct TitleView: View {
    @Binding var isGameActive: Bool
    @State private var showingDifficultySelection = false
    @State private var showingSettings = false
    var viewModel: GameViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("TitleImage")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                
                VStack(spacing: 20) {
                    Text("ACE HIGH")
                        .font(.system(size: geometry.size.width * 0.1, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 5, x: 0, y: 5)
                        .background(
                            Color.black.opacity(0.5)
                                .cornerRadius(10)
                                .padding(-10)
                        )

                    Text("SHOWDOWN")
                        .font(.system(size: geometry.size.width * 0.1, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 5, x: 0, y: 5)
                        .background(
                            Color.black.opacity(0.5)
                                .cornerRadius(10)
                                .padding(-10)
                        )

                    Button(action: {
                        showingDifficultySelection = true
                    }) {
                        Text("CPUと対戦")
                            .foregroundColor(.white)
                            .padding()
                            .font(.headline)
                            .frame(width: geometry.size.width * 0.8)
                    }
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(10)
                    .shadow(color: .black, radius: 2, x: 0, y: 2)
                    .fullScreenCover(isPresented: $showingDifficultySelection) {
                        DifficultySelectionView(isGameActive: $isGameActive, viewModel: viewModel)
                    }
                    
                    Button(action: {
                        showingSettings = true
                    }) {
                        Text("設定")
                            .foregroundColor(.white)
                            .padding()
                            .font(.headline)
                            .frame(width: geometry.size.width * 0.8)
                    }
                    .background(LinearGradient(gradient: Gradient(colors: [Color.brown, Color.purple]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(10)
                    .shadow(color: .black, radius: 2, x: 0, y: 2)
                    .fullScreenCover(isPresented: $showingSettings) {
                        SettingsView()
                    }
                }
                .padding()
            }
        }
    }
}
