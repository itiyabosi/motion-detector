import Foundation
import WatchConnectivity

class WatchConnectivityManager: NSObject, ObservableObject {
    static let shared = WatchConnectivityManager()

    @Published var isPhoneReachable = false

    private override init() {
        super.init()

        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }

    func sendMotionData(
        motionState: String,
        motionDescription: String,
        acceleration: Double,
        variance: Double,
        tremorDetected: Bool,
        tremorFrequency: Double,
        tremorAmplitude: Double,
        tremorConfidence: Double
    ) {
        guard WCSession.default.isReachable else { return }

        let message: [String: Any] = [
            "motionState": motionState,
            "motionDescription": motionDescription,
            "acceleration": acceleration,
            "variance": variance,
            "tremorDetected": tremorDetected,
            "tremorFrequency": tremorFrequency,
            "tremorAmplitude": tremorAmplitude,
            "tremorConfidence": tremorConfidence
        ]

        WCSession.default.sendMessage(message, replyHandler: nil) { error in
            print("Error sending message: \(error.localizedDescription)")
        }
    }
}

extension WatchConnectivityManager: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        DispatchQueue.main.async {
            self.isPhoneReachable = session.isReachable
        }
    }

    func sessionReachabilityDidChange(_ session: WCSession) {
        DispatchQueue.main.async {
            self.isPhoneReachable = session.isReachable
        }
    }
}
