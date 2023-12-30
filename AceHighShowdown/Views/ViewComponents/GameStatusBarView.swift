//  GameStatusBarView.swift

import SwiftUI

struct GameStatusBarView: View {
    @Binding var gameStatus: String
    @Binding var playerChoice: String?

    var body: some View {
        HStack {
            Text(gameStatus)
                .font(.headline)
                .foregroundColor(.white)
                .padding()
            
            Spacer()
            
            if let playerChoice = playerChoice {
                Text(playerChoice)
                    .font(.largeTitle)
                    .foregroundColor(playerChoice == "HIGH" ? .green : .red)
                    .padding()
            }
        }
        .background(Color.gray.opacity(0.8))
        .cornerRadius(10)
        .padding()
    }
}
