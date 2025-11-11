import SwiftUI
import Charts

struct ContentView: View {
    @StateObject private var watchConnectivity = WatchConnectivityManager()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // 接続状態
                    HStack {
                        Circle()
                            .fill(watchConnectivity.isWatchConnected ? Color.green : Color.gray)
                            .frame(width: 10, height: 10)
                        Text(watchConnectivity.isWatchConnected ? "Apple Watch接続済み" : "Apple Watch未接続")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }

                    // モーション状態カード
                    VStack(spacing: 10) {
                        Text(watchConnectivity.motionState)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(motionStateColor)

                        Text(watchConnectivity.motionDescription)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(15)

                    // メトリクス
                    HStack(spacing: 15) {
                        MetricCard(
                            label: "加速度",
                            value: String(format: "%.2f", watchConnectivity.acceleration),
                            unit: "m/s²",
                            color: .blue
                        )

                        MetricCard(
                            label: "変動率",
                            value: String(format: "%.3f", watchConnectivity.variance),
                            unit: "",
                            color: .orange
                        )
                    }

                    Divider()

                    // 振戦検出セクション
                    VStack(alignment: .leading, spacing: 15) {
                        Text("微細振動検出")
                            .font(.headline)

                        HStack {
                            Text("状態:")
                                .foregroundColor(.gray)
                            Spacer()
                            Text(watchConnectivity.tremorDetected ? "検出" : "検出なし")
                                .fontWeight(.bold)
                                .foregroundColor(watchConnectivity.tremorDetected ? .red : .green)
                        }

                        if watchConnectivity.tremorDetected {
                            HStack {
                                Text("周波数:")
                                    .foregroundColor(.gray)
                                Spacer()
                                Text("\(String(format: "%.1f", watchConnectivity.tremorFrequency)) Hz")
                                    .fontWeight(.semibold)
                            }

                            HStack {
                                Text("振幅:")
                                    .foregroundColor(.gray)
                                Spacer()
                                Text(String(format: "%.3f g", watchConnectivity.tremorAmplitude))
                                    .fontWeight(.semibold)
                            }

                            HStack {
                                Text("信頼度:")
                                    .foregroundColor(.gray)
                                Spacer()
                                Text("\(Int(watchConnectivity.tremorConfidence * 100))%")
                                    .fontWeight(.semibold)
                            }

                            // 周波数範囲インジケータ
                            VStack(alignment: .leading, spacing: 5) {
                                Text("周波数範囲: 3-12 Hz (病的振戦)")
                                    .font(.caption)
                                    .foregroundColor(.gray)

                                FrequencyBar(frequency: watchConnectivity.tremorFrequency)
                            }
                            .padding(.top, 10)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(15)

                    // グラフ（iOS 16+）
                    if #available(iOS 16.0, *), !watchConnectivity.accelerationHistory.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("加速度履歴")
                                .font(.headline)

                            Chart {
                                ForEach(Array(watchConnectivity.accelerationHistory.enumerated()), id: \.offset) { index, value in
                                    LineMark(
                                        x: .value("Time", index),
                                        y: .value("Acceleration", value)
                                    )
                                    .foregroundStyle(.blue)
                                }
                            }
                            .frame(height: 200)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.05))
                        .cornerRadius(15)
                    }

                    // 説明テキスト
                    VStack(alignment: .leading, spacing: 10) {
                        Text("使い方")
                            .font(.headline)
                        Text("1. Apple Watchアプリを開いて「開始」ボタンをタップ")
                        Text("2. 手を静止させたり動かしたりしてみてください")
                        Text("3. データがリアルタイムでiPhoneに同期されます")
                    }
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding()
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(15)
                }
                .padding()
            }
            .navigationTitle("モーション判定")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private var motionStateColor: Color {
        switch watchConnectivity.motionState {
        case "静止":
            return .blue
        case "滑らか":
            return .green
        case "動いている":
            return .red
        default:
            return .gray
        }
    }
}

struct MetricCard: View {
    let label: String
    let value: String
    let unit: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)

            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(color)

            if !unit.isEmpty {
                Text(unit)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

struct FrequencyBar: View {
    let frequency: Double

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // 背景バー
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 20)
                    .cornerRadius(10)

                // 範囲インジケータ（3-12 Hz）
                Rectangle()
                    .fill(Color.green.opacity(0.3))
                    .frame(width: geometry.size.width * (9.0 / 15.0), height: 20)
                    .offset(x: geometry.size.width * (3.0 / 15.0))
                    .cornerRadius(10)

                // 現在値
                Circle()
                    .fill(Color.red)
                    .frame(width: 12, height: 12)
                    .offset(x: max(0, min(geometry.size.width - 12, geometry.size.width * (frequency / 15.0))))
            }
        }
        .frame(height: 20)
    }
}

#Preview {
    ContentView()
}
