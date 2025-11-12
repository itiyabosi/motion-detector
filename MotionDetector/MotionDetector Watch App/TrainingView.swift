import SwiftUI

struct TrainingView: View {
    @StateObject private var trainer = TremorTrainer()
    @StateObject private var motionManager = MotionManager()
    @StateObject private var tremorDetector = TremorDetector()

    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 10) {
            if trainer.isTraining {
                // トレーニング中の表示
                trainingActiveView
            } else {
                // 待機中の表示
                trainingIdleView
            }
        }
        .padding()
        .onAppear {
            // モーションマネージャー開始
            motionManager.startUpdates()
        }
        .onDisappear {
            // 停止処理
            trainer.stopTraining()
            motionManager.stopUpdates()
        }
        .onChange(of: motionManager.axisDataX) { _ in
            updateTrainerData()
        }
    }

    // MARK: - Training Active View

    private var trainingActiveView: some View {
        VStack(spacing: 15) {
            // ステータス表示
            Text(trainer.feedbackMessage)
                .font(.headline)
                .foregroundColor(trainer.feedbackColor)

            // スコア表示
            Text("\(trainer.currentScore)")
                .font(.system(size: 70, weight: .bold))
                .foregroundColor(trainer.feedbackColor)

            Text("点")
                .font(.caption)
                .foregroundColor(.gray)

            // 視覚的フィードバック（ターゲットゾーン）
            ZStack {
                // 外側の円（目標ゾーン）
                Circle()
                    .stroke(Color.green.opacity(0.3), lineWidth: 4)
                    .frame(width: 120, height: 120)

                // 中間の円
                Circle()
                    .stroke(Color.yellow.opacity(0.3), lineWidth: 2)
                    .frame(width: 80, height: 80)

                // 中心点
                Circle()
                    .fill(Color.green.opacity(0.5))
                    .frame(width: 20, height: 20)

                // 現在位置インジケーター
                Circle()
                    .fill(trainer.feedbackColor)
                    .frame(width: 15, height: 15)
                    .shadow(color: trainer.feedbackColor.opacity(0.5), radius: 10)
                    .offset(y: CGFloat(trainer.currentTremorLevel * 50))
                    .animation(.spring(response: 0.3), value: trainer.currentTremorLevel)
            }
            .padding()

            // タイマー表示
            HStack {
                Image(systemName: "timer")
                    .foregroundColor(.gray)
                Text("残り \(trainer.timeRemaining)秒")
                    .font(.title3)
                    .fontWeight(.semibold)
            }

            // 安定性パーセンテージ
            if trainer.trainingState == .training {
                HStack {
                    Text("安定性:")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("\(Int(trainer.stabilityPercentage))%")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(stabilityColor)
                }
            }

            // 停止ボタン
            Button(action: {
                trainer.stopTraining()
            }) {
                Text("停止")
                    .font(.caption)
                    .foregroundColor(.red)
            }
            .buttonStyle(.bordered)
        }
    }

    // MARK: - Training Idle View

    private var trainingIdleView: some View {
        VStack(spacing: 20) {
            // タイトル
            Text("🎯 震えトレーニング")
                .font(.headline)

            // 統計情報
            VStack(spacing: 10) {
                StatRow(label: "ベストスコア", value: "\(trainer.bestScore)点", color: .yellow)
                StatRow(label: "トレーニング回数", value: "\(trainer.sessionCount)回", color: .blue)
                StatRow(label: "連続日数", value: "\(trainer.currentStreak)日", color: .orange)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(15)

            // 説明
            Text("30秒間、手を安定させてください")
                .font(.caption)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)

            // 開始ボタン
            Button(action: {
                trainer.startTraining()
            }) {
                Label("開始", systemImage: "play.fill")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(10)
            }
            .buttonStyle(.plain)

            // 戻るボタン
            Button(action: {
                dismiss()
            }) {
                Text("戻る")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - Helper Views

    private var stabilityColor: Color {
        let percentage = trainer.stabilityPercentage
        if percentage >= 80 {
            return .green
        } else if percentage >= 60 {
            return .yellow
        } else {
            return .orange
        }
    }

    // MARK: - Data Update

    private func updateTrainerData() {
        // 最新のモーションデータをTremorDetectorに渡す
        if motionManager.axisDataX.count >= 100 {
            // X, Y, Z軸の検出結果を取得
            let xResult = tremorDetector.detectTremor(data: motionManager.axisDataX)
            let yResult = tremorDetector.detectTremor(data: motionManager.axisDataY)
            let zResult = tremorDetector.detectTremor(data: motionManager.axisDataZ)

            // いずれかの軸で振戦検出されたか
            let hasTremor = xResult != nil || yResult != nil || zResult != nil

            // 最新の加速度と分散を計算
            let recentData = Array(motionManager.axisDataX.suffix(20))
            let variance = calculateVariance(recentData)
            let acceleration = recentData.last ?? 0.0

            // Trainerに渡す
            trainer.updateTremorData(
                acceleration: abs(acceleration),
                variance: variance,
                tremor: hasTremor
            )
        }
    }

    private func calculateVariance(_ data: [Double]) -> Double {
        guard !data.isEmpty else { return 0.0 }
        let mean = data.reduce(0.0, +) / Double(data.count)
        let squaredDifferences = data.map { pow($0 - mean, 2) }
        return squaredDifferences.reduce(0.0, +) / Double(data.count)
    }
}

// MARK: - Supporting Views

struct StatRow: View {
    let label: String
    let value: String
    let color: Color

    var body: some View {
        HStack {
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(color)
        }
    }
}

#Preview {
    TrainingView()
}
