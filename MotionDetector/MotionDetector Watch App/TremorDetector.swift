import Foundation
import Combine

class TremorDetector: ObservableObject {
    @Published var isDetected: Bool = false
    @Published var frequency: Double = 0.0
    @Published var amplitude: Double = 0.0
    @Published var confidence: Double = 0.0

    private var cancellables = Set<AnyCancellable>()
    private var timer: Timer?

    // 検出パラメータ
    private let windowSize = 100 // 2秒分（50Hz）
    private let minFreq = 3.0    // 最小周波数 (Hz)
    private let maxFreq = 12.0   // 最大周波数 (Hz)
    private let threshold = 0.06 // 振幅閾値 (g)
    private let sampleRate = 50.0 // サンプリングレート (Hz)

    func startDetection(with motionManager: MotionManager) {
        // 1秒ごとに振戦検出を実行
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.detectTremor(motionManager: motionManager)
        }
    }

    func reset() {
        timer?.invalidate()
        timer = nil
        isDetected = false
        frequency = 0.0
        amplitude = 0.0
        confidence = 0.0
    }

    private func detectTremor(motionManager: MotionManager) {
        guard motionManager.axisDataX.count >= windowSize else {
            return
        }

        // 各軸で周波数検出
        let dataX = Array(motionManager.axisDataX.suffix(windowSize))
        let dataY = Array(motionManager.axisDataY.suffix(windowSize))
        let dataZ = Array(motionManager.axisDataZ.suffix(windowSize))

        let resultX = detectDominantFrequency(data: dataX)
        let resultY = detectDominantFrequency(data: dataY)
        let resultZ = detectDominantFrequency(data: dataZ)

        let results = [resultX, resultY, resultZ].compactMap { $0 }

        guard !results.isEmpty else {
            isDetected = false
            return
        }

        // 最も強い信号を選択
        guard let dominant = results.max(by: { $0.correlation < $1.correlation }) else {
            isDetected = false
            return
        }

        let freq = dominant.frequency
        let amp = dominant.amplitude

        // 振戦範囲内かチェック
        if freq >= minFreq && freq <= maxFreq && amp >= threshold {
            isDetected = true
            frequency = freq
            amplitude = amp

            // 信頼度計算（周波数の一貫性）
            let consistentResults = results.filter { abs($0.frequency - freq) < 1.0 }
            confidence = Double(consistentResults.count) / Double(results.count)
        } else {
            isDetected = false
            frequency = freq
            amplitude = amp
            confidence = 0.0
        }
    }

    private func detectDominantFrequency(data: [Double]) -> (frequency: Double, amplitude: Double, correlation: Double)? {
        guard data.count >= 20 else { return nil }

        // データを正規化（平均を0に）
        let mean = data.reduce(0, +) / Double(data.count)
        let normalized = data.map { $0 - mean }

        // 自己相関を計算
        let maxLag = min(data.count / 2, Int(sampleRate / minFreq))
        var bestLag = 0
        var bestCorrelation = -Double.infinity

        for lag in Int(sampleRate / maxFreq)...maxLag {
            var correlation = 0.0
            for i in 0..<(data.count - lag) {
                correlation += normalized[i] * normalized[i + lag]
            }

            if correlation > bestCorrelation {
                bestCorrelation = correlation
                bestLag = lag
            }
        }

        guard bestLag > 0 else { return nil }

        let frequency = sampleRate / Double(bestLag)
        let amplitude = sqrt(normalized.reduce(0) { $0 + $1 * $1 } / Double(normalized.count))

        return (frequency: frequency, amplitude: amplitude, correlation: bestCorrelation)
    }
}
