# モーション判定アプリ

スマホの加速度センサーを使って、手の動きを判定するアプリです。

## バージョン

このプロジェクトには2つのバージョンがあります：

1. **Webアプリ版** - スマートフォンのブラウザで動作
2. **Apple Watch版** - Apple Watch + iPhone ネイティブアプリ

## 機能

### 基本的なモーション判定
- リアルタイムで手の状態を判定
  - 静止: 変動 < 0.05（ほとんど動いていない）
  - 滑らか: 変動 < 0.3（変動が少ない）
  - 動いている: 変動 ≥ 0.3（変動が大きい）

### 微細振動検出
- 3軸加速度センサーを用いた周波数解析
- 3-12 Hz範囲の周期的な微細振動を検出
- 自己相関ベースの周波数推定アルゴリズム
- 検出パラメータ：
  - 周波数範囲: 3-12 Hz（病的振戦の典型的範囲）
  - 振幅閾値: 0.06 g以上
  - 窓サイズ: 2秒（100サンプル）
  - 信頼度評価: 各軸間の周波数一貫性

### その他の機能
- 加速度データのリアルタイムグラフ表示
- 状態変化のタイムスタンプ付きログ記録

---

## Webアプリ版の使い方

### オンラインで使用

GitHub Pagesで公開しているので、スマホのブラウザで以下のURLにアクセスしてください：

**https://itiyabosi.github.io/motion-detector/**

「センサーを開始」ボタンをタップして、スマホを動かしてみてください。

注意: GitHub Pagesのデプロイには数分かかる場合があります。

### ローカルで実行

```bash
python3 -m http.server 8000
```

ブラウザで `http://localhost:8000` にアクセス

---

## Apple Watch版の使い方

Apple Watch + iPhone のネイティブアプリ版を作成できます。

### 特徴

- Apple Watch単体で動作
- iPhoneアプリで詳細なデータ表示
- Watch Connectivityでリアルタイム同期
- より正確なセンサーデータ取得

### セットアップ

詳細な手順は **[WATCH_APP_SETUP.md](./WATCH_APP_SETUP.md)** を参照してください。

**簡単な流れ：**

1. Xcodeで新規プロジェクトを作成
2. Watch Appターゲットを追加
3. 提供されているSwiftファイルを配置
4. ビルド＆実行

**必要なもの：**
- Mac（Xcodeが動作する）
- Apple Watch + iPhone
- Apple ID（無料アカウントでOK、ただし7日ごとに再署名が必要）

**ファイル構成：**
```
MotionDetectorWatch/     # Apple Watch アプリ用
  - ContentView.swift
  - MotionManager.swift
  - TremorDetector.swift
  - WatchConnectivityManager.swift
  - MotionDetectorWatchApp.swift

MotionDetectorPhone/     # iPhone アプリ用
  - ContentView.swift
  - WatchConnectivityManager.swift
  - MotionDetectorPhoneApp.swift
```

---

## 技術詳細

### アルゴリズム

**モーション判定**
- 移動窓による分散計算（20サンプル）
- 3段階の閾値判定

**振戦検出**
- 自己相関法による周波数推定
- 各軸（X, Y, Z）独立解析
- 信頼度スコアリング

### 参考文献

実装は以下の医学研究に基づいています：
- スマートフォン加速度センサーを用いた振戦検出（感度97.96%）
- 病的振戦の周波数範囲: 3-12 Hz
- パーキンソン病振戦: 3-6 Hz
- 本態性振戦: 4-12 Hz

---

## プロジェクト構成

```
.
├── index.html                    # Webアプリ版
├── README.md                     # このファイル
├── WATCH_APP_SETUP.md           # Apple Watch版セットアップガイド
├── MotionDetectorWatch/         # Apple Watch用Swiftファイル
└── MotionDetectorPhone/         # iPhone用Swiftファイル
```
