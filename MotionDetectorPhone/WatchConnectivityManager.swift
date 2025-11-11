import Foundation
import WatchConnectivity

class WatchConnectivityManager: NSObject, ObservableObject {
    @Published var isWatchConnected = false
    @Published var motionState = "待機中"
    @Published var motionDescription = "Watchアプリを起動してください"
    @Published var acceleration: Double = 0.0
    @Published var variance: Double = 0.0
    @Published var tremorDetected = false
    @Published var tremorFrequency: Double = 0.0
    @Published var tremorAmplitude: Double = 0.0
    @Published var tremorConfidence: Double = 0.0
    @Published var accelerationHistory: [Double] = []

    private let maxHistoryPoints = 50

    override init() {
        super.init()

        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
}

extension WatchConnectivityManager: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        DispatchQueue.main.async {
            self.isWatchConnected = session.isReachable
        }
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        DispatchQueue.main.async {
            self.isWatchConnected = false
        }
    }

    func sessionDidDeactivate(_ session: WCSession) {
        DispatchQueue.main.async {
            self.isWatchConnected = false
        }
    }

    func sessionReachabilityDidChange(_ session: WCSession) {
        DispatchQueue.main.async {
            self.isWatchConnected = session.isReachable
        }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            // モーション状態
            if let state = message["motionState"] as? String {
                self.motionState = state
            }

            if let description = message["motionDescription"] as? String {
                self.motionDescription = description
            }

            // メトリクス
            if let acc = message["acceleration"] as? Double {
                self.acceleration = acc
                self.accelerationHistory.append(acc)

                if self.accelerationHistory.count > self.maxHistoryPoints {
                    self.accelerationHistory.removeFirst()
                }
            }

            if let variance = message["variance"] as? Double {
                self.variance = variance
            }

            // 振戦検出
            if let detected = message["tremorDetected"] as? Bool {
                self.tremorDetected = detected
            }

            if let freq = message["tremorFrequency"] as? Double {
                self.tremorFrequency = freq
            }

            if let amp = message["tremorAmplitude"] as? Double {
                self.tremorAmplitude = amp
            }

            if let conf = message["tremorConfidence"] as? Double {
                self.tremorConfidence = conf
            }
        }
    }
}
