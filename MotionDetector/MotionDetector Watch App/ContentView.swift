import SwiftUI

struct ContentView: View {
    @StateObject private var motionManager = MotionManager()
    @StateObject private var tremorDetector = TremorDetector()
    @StateObject private var connectivity = WatchConnectivityManager.shared

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 15) {
                // モーション状態
                VStack(spacing: 5) {
                    Text(motionManager.motionState.label)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(motionStateColor)

                    Text(motionManager.motionState.description)
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                // メトリクス
                HStack(spacing: 10) {
                    MetricView(label: "加速度", value: String(format: "%.2f", motionManager.acceleration), unit: "m/s²")
                    MetricView(label: "変動", value: String(format: "%.2f", motionManager.variance), unit: "")
                }

                Divider()

                // 振戦検出
                VStack(spacing: 5) {
                    Text("微細振動")
                        .font(.caption)
                        .foregroundColor(.gray)

                    Text(tremorDetector.isDetected ? "検出" : "検出なし")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(tremorDetector.isDetected ? .red : .green)
                }

                if tremorDetector.isDetected {
                    HStack(spacing: 10) {
                        MetricView(label: "周波数", value: String(format: "%.1f", tremorDetector.frequency), unit: "Hz")
                        MetricView(label: "信頼度", value: String(format: "%d", Int(tremorDetector.confidence * 100)), unit: "%")
                    }
                }

                // コントロール
                Button(action: {
                    if motionManager.isMonitoring {
                        motionManager.stopMonitoring()
                        tremorDetector.reset()
                    } else {
                        motionManager.startMonitoring()
                        tremorDetector.startDetection(with: motionManager)
                    }
                }) {
                    Text(motionManager.isMonitoring ? "停止" : "開始")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(8)
                        .background(motionManager.isMonitoring ? Color.red : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Divider()

                // トレーニングモード
                NavigationLink(destination: TrainingView()) {
                    HStack {
                        Image(systemName: "figure.strengthtraining.traditional")
                        Text("トレーニング")
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(8)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .buttonStyle(.plain)
            }
            .padding()
            }
            .navigationTitle("モーション判定")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onChange(of: motionManager.acceleration) { _ in
            sendDataToPhone()
        }
        .onChange(of: tremorDetector.isDetected) { _ in
            sendDataToPhone()
        }
    }

    private func sendDataToPhone() {
        connectivity.sendMotionData(
            motionState: motionManager.motionState.label,
            motionDescription: motionManager.motionState.description,
            acceleration: motionManager.acceleration,
            variance: motionManager.variance,
            tremorDetected: tremorDetector.isDetected,
            tremorFrequency: tremorDetector.frequency,
            tremorAmplitude: tremorDetector.amplitude,
            tremorConfidence: tremorDetector.confidence
        )
    }

    private var motionStateColor: Color {
        switch motionManager.motionState.state {
        case .static:
            return .blue
        case .smooth:
            return .green
        case .moving:
            return .red
        }
    }
}

struct MetricView: View {
    let label: String
    let value: String
    let unit: String

    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
            Text(label)
                .font(.caption2)
                .foregroundColor(.gray)
            if !unit.isEmpty {
                Text(unit)
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(8)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

#Preview {
    ContentView()
}
