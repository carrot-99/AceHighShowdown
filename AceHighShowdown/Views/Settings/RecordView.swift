//  RecordView.swift

import SwiftUI

struct RecordView: View {
    var body: some View {
        let defaults = UserDefaults.standard
        let winsEasy = defaults.integer(forKey: Keys.winsEasy)
        let lossesEasy = defaults.integer(forKey: Keys.lossesEasy)
        let drawsEasy = defaults.integer(forKey: Keys.drawsEasy)
        let winsNormal = defaults.integer(forKey: Keys.winsNormal)
        let lossesNormal = defaults.integer(forKey: Keys.lossesNormal)
        let drawsNormal = defaults.integer(forKey: Keys.drawsNormal)
        let winsHard = defaults.integer(forKey: Keys.winsHard)
        let lossesHard = defaults.integer(forKey: Keys.lossesHard)
        let drawsHard = defaults.integer(forKey: Keys.drawsHard)
        
        VStack(alignment: .leading, spacing: 10) {
            Text("戦績")
                .font(.title)
                .bold()
            
            Divider()
            
            HStack {
                Text("難易度")
                    .font(.headline)
                    .frame(width: 100, alignment: .leading)
                Spacer()
                Text("勝利")
                    .font(.headline)
                Spacer()
                Text("敗北")
                    .font(.headline)
                Spacer()
                Text("引き分け")
                    .font(.headline)
            }
            
            RecordRow(difficulty: "Easy", wins: winsEasy, losses: lossesEasy, draws: drawsEasy)
            RecordRow(difficulty: "Normal", wins: winsNormal, losses: lossesNormal, draws: drawsNormal)
            RecordRow(difficulty: "Hard", wins: winsHard, losses: lossesHard, draws: drawsHard)
        }
        .padding()
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(20)
    }
}

struct RecordRow: View {
    var difficulty: String
    var wins: Int
    var losses: Int
    var draws: Int
    
    var body: some View {
        HStack {
            Text(difficulty)
                .frame(width: 100, alignment: .leading)
            Spacer()
            Text("\(wins)")
            Spacer()
            Text("\(losses)")
            Spacer()
            Text("\(draws)")
        }
        .padding(.vertical, 2)
    }
}
