# Apple Watch モーション判定アプリ - セットアップガイド

このガイドでは、Apple Watch + iPhoneのモーション判定アプリをXcodeで作成する方法を説明します。

## 前提条件

- macOS（Xcodeが動作する環境）
- Xcode 15.0以降
- Apple ID（無料アカウントでOK）
- Apple Watch（watchOS 9.0以降推奨）
- iPhone（iOS 16.0以降推奨）

## プロジェクト作成手順

### 1. Xcodeプロジェクトの作成

1. Xcodeを起動
2. "Create a new Xcode project"を選択
3. **iOS** タブから "App" を選択 → Next
4. プロジェクト設定：
   - Product Name: `MotionDetector`
   - Team: あなたのApple ID
   - Organization Identifier: `com.yourname`（任意）
   - Interface: **SwiftUI**
   - Language: **Swift**
   - Include Tests: チェックなしでOK
5. プロジェクトの保存場所を選択 → Create

### 2. Watch Appターゲットの追加

1. Xcodeのメニューから **File → New → Target** を選択
2. **watchOS** タブから "Watch App" を選択 → Next
3. 設定：
   - Product Name: `MotionDetector Watch App`
   - Interface: **SwiftUI**
   - Language: **Swift**
4. Finish → **Activate** を選択

### 3. ファイルの配置

#### iPhoneアプリ用ファイル

`MotionDetector`フォルダに以下のファイルを追加：

1. **ContentView.swift を置き換え**
   - 既存のContentView.swiftを削除
   - `MotionDetectorPhone/ContentView.swift` をプロジェクトにドラッグ&ドロップ
   - Target: `MotionDetector` にチェック

2. **WatchConnectivityManager.swift を追加**
   - `MotionDetectorPhone/WatchConnectivityManager.swift` をプロジェクトにドラッグ&ドロップ
   - Target: `MotionDetector` にチェック

3. **App ファイル**
   - 既存の `MotionDetectorApp.swift` を開く
   - `MotionDetectorPhone/MotionDetectorPhoneApp.swift` の内容で置き換え

#### Apple Watch アプリ用ファイル

`MotionDetector Watch App`フォルダに以下のファイルを追加：

1. **ContentView.swift を置き換え**
   - 既存のContentView.swiftを削除
   - `MotionDetectorWatch/ContentView.swift` をプロジェクトにドラッグ&ドロップ
   - Target: `MotionDetector Watch App` にチェック

2. **MotionManager.swift を追加**
   - `MotionDetectorWatch/MotionManager.swift` をプロジェクトにドラッグ&ドロップ
   - Target: `MotionDetector Watch App` にチェック

3. **TremorDetector.swift を追加**
   - `MotionDetectorWatch/TremorDetector.swift` をプロジェクトにドラッグ&ドロップ
   - Target: `MotionDetector Watch App` にチェック

4. **WatchConnectivityManager.swift を追加**
   - `MotionDetectorWatch/WatchConnectivityManager.swift` をプロジェクトにドラッグ&ドロップ
   - Target: `MotionDetector Watch App` にチェック

5. **App ファイル**
   - 既存の Watch App ファイル（`MotionDetector_Watch_AppApp.swift` など）を開く
   - `MotionDetectorWatch/MotionDetectorWatchApp.swift` の内容で置き換え

### 4. 権限の追加

#### iPhoneアプリ

1. プロジェクトナビゲータで `MotionDetector` を選択
2. **Signing & Capabilities** タブを開く
3. **+ Capability** をクリック
4. "Background Modes" を追加
   - **Background fetch** にチェック（オプション）

#### Apple Watchアプリ

1. プロジェクトナビゲータで `MotionDetector Watch App` を選択
2. **Info** タブを開く
3. Custom iOS Target Properties に以下を追加：
   - Key: `NSMotionUsageDescription`
   - Value: `加速度センサーを使用して手の動きを検出します`
   - Type: String

または、Info.plistに直接追加：
```xml
<key>NSMotionUsageDescription</key>
<string>加速度センサーを使用して手の動きを検出します</string>
```

### 5. Deployment Targetの設定

1. **iPhone アプリ**
   - Project → MotionDetector → General
   - Minimum Deployments: **iOS 16.0** 以降

2. **Watch アプリ**
   - Project → MotionDetector Watch App → General
   - Minimum Deployments: **watchOS 9.0** 以降

### 6. ビルドとインストール

#### iPhoneアプリ

1. スキームで **MotionDetector** を選択
2. デバイスで実機を選択（シミュレータでも動作しますが、センサーは使えません）
3. ▶️ボタンでビルド＆実行

初回は署名エラーが出る場合：
1. **Signing & Capabilities** タブを開く
2. **Automatically manage signing** にチェック
3. **Team** で自分のApple IDを選択
4. Bundle Identifierが自動的に設定されます

#### Apple Watchアプリ

1. iPhoneとApple Watchをペアリング
2. スキームで **MotionDetector Watch App** を選択
3. デバイスで Apple Watch を選択
4. ▶️ボタンでビルド＆実行

**注意**: 無料のApple IDの場合、アプリの署名は7日間で期限切れになります。その後も使い続けるには、再度ビルド＆インストールが必要です。

## 使い方

### Apple Watchで

1. Apple Watchアプリを開く
2. **開始**ボタンをタップ
3. 手を静止させたり動かしたりしてみてください
4. リアルタイムで状態が表示されます

### iPhoneで

1. iPhoneアプリを開く
2. Apple Watchが接続されていることを確認（画面上部の緑の●）
3. Apple Watchでセンサーを開始すると、データがリアルタイムで同期されます
4. より詳細な情報とグラフが表示されます

## トラブルシューティング

### ビルドエラーが出る

- Xcodeを最新版にアップデート
- プロジェクトを Clean (⌘+Shift+K) してから再ビルド
- Derived Data を削除: Xcode → Preferences → Locations → Derived Data → 矢印アイコンをクリックしてフォルダを開き、削除

### センサーが動かない

- Info.plistに `NSMotionUsageDescription` が追加されているか確認
- Watchアプリで権限が許可されているか確認（設定アプリ → プライバシー → モーションとフィットネス）

### Watch Connectivityが接続されない

- iPhoneとApple Watchが正しくペアリングされているか確認
- 両方のアプリが同時に起動しているか確認
- 一度両方のアプリを再起動してみる

### 7日で署名が切れる

無料のApple IDを使用している場合の制限です。以下の対処法があります：

1. 7日ごとにXcodeから再インストール
2. Apple Developer Program（年間99ドル）に登録

## 機能詳細

### 基本的なモーション判定
- **静止**: 変動 < 0.05
- **滑らか**: 変動 < 0.3（変動が少ない）
- **動いている**: 変動 ≥ 0.3

### 微細振動検出
- 周波数範囲: 3-12 Hz（病的振戦の典型的範囲）
- 振幅閾値: 0.06 g以上
- 窓サイズ: 2秒（100サンプル）
- 自己相関ベースの周波数推定アルゴリズム
- 各軸（X, Y, Z）独立解析

## 次のステップ

- TestFlightでの配布（Apple Developer Programが必要）
- App Storeでの公開（Apple Developer Programが必要）
- HealthKitとの連携
- データのエクスポート機能

## ライセンス

このコードは自由に使用・改変できます。
