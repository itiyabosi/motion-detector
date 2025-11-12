import SwiftUI
import Combine

/// トレーニングセッションの状態
enum TrainingState {
    case idle           // 待機中
    case warmup         // ウォームアップ
    case baseline       // ベースライン測定
    case training       // トレーニング中
    case cooldown       // クールダウン
    case completed      // 完了
}

/// 震えトレーニングマネージャー
class TremorTrainer: ObservableObject {
    // MARK: - Published Properties
    @Published var currentScore: Int = 0
    @Published var bestScore: Int = 0
    @Published var sessionCount: Int = 0
    @Published var currentStreak: Int = 0

    @Published var trainingState: TrainingState = .idle
    @Published var timeRemaining: Int = 30
    @Published var isTraining: Bool = false

    @Published var currentTremorLevel: Double = 0.0  // 0.0-1.0 (0=完璧, 1=震え大)
    @Published var stabilityPercentage: Double = 0.0  // 安定している時間の割合

    @Published var feedbackColor: Color = .gray
    @Published var feedbackMessage: String = "準備中..."

    // MARK: - Private Properties
    private var timer: Timer?
    private var trainingDuration: Int = 30  // 秒
    private var stableTimeCount: Double = 0  // 安定していた時間（秒）
    private var totalTimeCount: Double = 0   // 総時間（秒）

    // スコア計算の閾値
    private let excellentThreshold: Double = 0.02  // g
    private let goodThreshold: Double = 0.04       // g
    private let fairThreshold: Double = 0.06       // g

    // UserDefaults keys
    private let bestScoreKey = "bestTrainingScore"
    private let sessionCountKey = "trainingSessionCount"
    private let streakKey = "trainingStreak"
    private let lastTrainingDateKey = "lastTrainingDate"

    // MARK: - Initialization
    init() {
        loadProgress()
    }

    // MARK: - Public Methods

    /// トレーニングセッション開始
    func startTraining() {
        guard !isTraining else { return }

        isTraining = true
        trainingState = .warmup
        timeRemaining = 5  // ウォームアップ5秒
        stableTimeCount = 0
        totalTimeCount = 0
        currentScore = 0

        feedbackMessage = "リラックスして..."
        feedbackColor = .blue

        startTimer()
    }

    /// トレーニングセッション停止
    func stopTraining() {
        timer?.invalidate()
        timer = nil
        isTraining = false
        trainingState = .idle
        feedbackMessage = "準備中..."
        feedbackColor = .gray
    }

    /// リアルタイムで震えデータを更新（MotionManagerから呼ばれる）
    func updateTremorData(acceleration: Double, variance: Double, tremor: Bool) {
        guard isTraining && trainingState == .training else { return }

        // 震えレベルを0-1に正規化
        // variance: 0.0001 (静止) ~ 0.1+ (激しい動き)
        let normalizedTremor = min(1.0, variance * 10.0)
        currentTremorLevel = normalizedTremor

        // スコア計算（100点満点）
        let instantScore = calculateInstantScore(variance: variance)

        // 移動平均でスコアを滑らかに
        currentScore = Int((Double(currentScore) * 0.8 + Double(instantScore) * 0.2))

        // 安定時間のカウント
        totalTimeCount += 0.02  // 50Hzなので0.02秒ごと
        if variance < goodThreshold {
            stableTimeCount += 0.02
        }

        // 安定性パーセンテージ
        stabilityPercentage = (stableTimeCount / totalTimeCount) * 100.0

        // フィードバック更新
        updateFeedback(score: instantScore)
    }

    /// 即座のスコア計算
    private func calculateInstantScore(variance: Double) -> Int {
        if variance < excellentThreshold {
            return Int(95 + (excellentThreshold - variance) / excellentThreshold * 5)  // 95-100点
        } else if variance < goodThreshold {
            let range = goodThreshold - excellentThreshold
            let position = (goodThreshold - variance) / range
            return Int(80 + position * 15)  // 80-95点
        } else if variance < fairThreshold {
            let range = fairThreshold - goodThreshold
            let position = (fairThreshold - variance) / range
            return Int(60 + position * 20)  // 60-80点
        } else {
            return max(0, Int(60 - (variance - fairThreshold) * 200))  // 0-60点
        }
    }

    /// フィードバック更新
    private func updateFeedback(score: Int) {
        switch score {
        case 90...100:
            feedbackColor = .green
            feedbackMessage = "完璧です！"
        case 80..<90:
            feedbackColor = Color(red: 0.6, green: 0.8, blue: 0.3)
            feedbackMessage = "素晴らしい！"
        case 70..<80:
            feedbackColor = .yellow
            feedbackMessage = "良い調子"
        case 60..<70:
            feedbackColor = .orange
            feedbackMessage = "もう少し"
        default:
            feedbackColor = .red
            feedbackMessage = "リラックス"
        }
    }

    // MARK: - Private Methods

    /// タイマー開始
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.timerTick()
        }
    }

    /// タイマー毎秒処理
    private func timerTick() {
        timeRemaining -= 1

        switch trainingState {
        case .warmup:
            if timeRemaining <= 0 {
                // ウォームアップ完了 → ベースライン測定
                trainingState = .baseline
                timeRemaining = 5
                feedbackMessage = "測定中..."
                feedbackColor = .blue
            }

        case .baseline:
            if timeRemaining <= 0 {
                // ベースライン完了 → メイントレーニング
                trainingState = .training
                timeRemaining = trainingDuration
                feedbackMessage = "スタート！"
                feedbackColor = .green
            }

        case .training:
            if timeRemaining <= 0 {
                // トレーニング完了 → クールダウン
                trainingState = .cooldown
                timeRemaining = 3
                feedbackMessage = "お疲れ様！"
                feedbackColor = .blue

                // 統計保存
                completeTraining()
            }

        case .cooldown:
            if timeRemaining <= 0 {
                // すべて完了
                trainingState = .completed
                feedbackMessage = "完了！"
                stopTraining()
            }

        default:
            break
        }
    }

    /// トレーニング完了処理
    private func completeTraining() {
        // ベストスコア更新
        if currentScore > bestScore {
            bestScore = currentScore
            UserDefaults.standard.set(bestScore, forKey: bestScoreKey)
        }

        // セッション回数更新
        sessionCount += 1
        UserDefaults.standard.set(sessionCount, forKey: sessionCountKey)

        // ストリーク更新
        updateStreak()
    }

    /// ストリーク（連続日数）更新
    private func updateStreak() {
        let today = Calendar.current.startOfDay(for: Date())

        if let lastDate = UserDefaults.standard.object(forKey: lastTrainingDateKey) as? Date {
            let lastTrainingDay = Calendar.current.startOfDay(for: lastDate)
            let daysDifference = Calendar.current.dateComponents([.day], from: lastTrainingDay, to: today).day ?? 0

            if daysDifference == 0 {
                // 同じ日
                // ストリークは変更なし
            } else if daysDifference == 1 {
                // 連続
                currentStreak += 1
            } else {
                // 途切れた
                currentStreak = 1
            }
        } else {
            // 初回
            currentStreak = 1
        }

        UserDefaults.standard.set(currentStreak, forKey: streakKey)
        UserDefaults.standard.set(Date(), forKey: lastTrainingDateKey)
    }

    /// 進捗ロード
    private func loadProgress() {
        bestScore = UserDefaults.standard.integer(forKey: bestScoreKey)
        sessionCount = UserDefaults.standard.integer(forKey: sessionCountKey)
        currentStreak = UserDefaults.standard.integer(forKey: streakKey)
    }

    /// 統計リセット（デバッグ用）
    func resetProgress() {
        bestScore = 0
        sessionCount = 0
        currentStreak = 0
        UserDefaults.standard.set(0, forKey: bestScoreKey)
        UserDefaults.standard.set(0, forKey: sessionCountKey)
        UserDefaults.standard.set(0, forKey: streakKey)
        UserDefaults.standard.removeObject(forKey: lastTrainingDateKey)
    }
}
