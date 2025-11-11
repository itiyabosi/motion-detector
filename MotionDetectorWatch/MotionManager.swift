import Foundation
import CoreMotion
import Combine

enum MotionStateType {
    case `static`
    case smooth
    case moving
}

struct MotionState {
    let state: MotionStateType
    let label: String
    let description: String
}

class MotionManager: ObservableObject {
    @Published var acceleration: Double = 0.0
    @Published var variance: Double = 0.0
    @Published var motionState: MotionState = MotionState(
        state: .static,
        label: "待機中",
        description: "開始ボタンを押してください"
    )
    @Published var isMonitoring: Bool = false

    // 生の加速度データ（振戦検出用）
    @Published var axisDataX: [Double] = []
    @Published var axisDataY: [Double] = []
    @Published var axisDataZ: [Double] = []

    private let motionManager = CMMotionManager()
    private var accelerationData: [Double] = []
    private let samplingWindow = 20
    private let maxDataPoints = 200

    // 閾値
    private let staticThreshold = 0.05
    private let smoothThreshold = 0.3

    func startMonitoring() {
        guard motionManager.isAccelerometerAvailable else {
            print("Accelerometer not available")
            return
        }

        motionManager.accelerometerUpdateInterval = 1.0 / 50.0 // 50Hz

        motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, error in
            guard let self = self, let data = data else { return }

            let acc = data.acceleration
            let magnitude = sqrt(acc.x * acc.x + acc.y * acc.y + acc.z * acc.z) * 9.81

            // 各軸のデータを保存（g単位）
            self.axisDataX.append(acc.x)
            self.axisDataY.append(acc.y)
            self.axisDataZ.append(acc.z)

            // データサイズを制限
            if self.axisDataX.count > self.maxDataPoints {
                self.axisDataX.removeFirst()
                self.axisDataY.removeFirst()
                self.axisDataZ.removeFirst()
            }

            // 合成加速度データを保存
            self.accelerationData.append(magnitude)
            if self.accelerationData.count > self.samplingWindow {
                self.accelerationData.removeFirst()
            }

            // 分散を計算
            let variance = self.calculateVariance(self.accelerationData)
            self.variance = variance

            // 状態を判定
            let state = self.determineMotionState(variance: variance)
            self.motionState = state
            self.acceleration = magnitude
        }

        isMonitoring = true
    }

    func stopMonitoring() {
        motionManager.stopAccelerometerUpdates()
        isMonitoring = false
        accelerationData.removeAll()
        axisDataX.removeAll()
        axisDataY.removeAll()
        axisDataZ.removeAll()
        acceleration = 0.0
        variance = 0.0
        motionState = MotionState(
            state: .static,
            label: "停止",
            description: "開始ボタンを押してください"
        )
    }

    private func calculateVariance(_ data: [Double]) -> Double {
        guard data.count >= 2 else { return 0 }

        let mean = data.reduce(0, +) / Double(data.count)
        let variance = data.reduce(0) { sum, value in
            sum + pow(value - mean, 2)
        } / Double(data.count)

        return variance
    }

    private func determineMotionState(variance: Double) -> MotionState {
        if variance < staticThreshold {
            return MotionState(
                state: .static,
                label: "静止",
                description: "ほとんど動いていません"
            )
        } else if variance < smoothThreshold {
            return MotionState(
                state: .smooth,
                label: "滑らか",
                description: "変動が少ない"
            )
        } else {
            return MotionState(
                state: .moving,
                label: "動いている",
                description: "変動が大きい"
            )
        }
    }
}
