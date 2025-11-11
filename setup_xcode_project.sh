#!/bin/bash

# Xcode プロジェクト自動セットアップスクリプト

echo "🔧 Xcodeプロジェクトのセットアップを開始します..."

# プロジェクトディレクトリを検索
PROJECT_DIR="MotionDetector"

if [ ! -d "$PROJECT_DIR" ]; then
    echo "❌ エラー: MotionDetectorプロジェクトが見つかりません"
    echo "このスクリプトは以下のディレクトリで実行してください："
    echo "/Users/hikaru/00/2025/12 スマホの加速度センサ"
    exit 1
fi

echo "✅ プロジェクトディレクトリを発見: $PROJECT_DIR"

# iPhoneアプリ用ディレクトリ
PHONE_TARGET_DIR="$PROJECT_DIR/MotionDetector"

# Watchアプリ用ディレクトリ
WATCH_TARGET_DIR="$PROJECT_DIR/MotionDetector Watch App"

echo ""
echo "📱 iPhoneアプリファイルをコピー中..."

# iPhoneアプリファイルをコピー
if [ -d "$PHONE_TARGET_DIR" ]; then
    # 既存のContentView.swiftを削除
    if [ -f "$PHONE_TARGET_DIR/ContentView.swift" ]; then
        echo "  - 既存のContentView.swiftを削除"
        rm "$PHONE_TARGET_DIR/ContentView.swift"
    fi

    # 新しいファイルをコピー
    echo "  - ContentView.swiftをコピー"
    cp "MotionDetectorPhone/ContentView.swift" "$PHONE_TARGET_DIR/"

    echo "  - WatchConnectivityManager.swiftをコピー"
    cp "MotionDetectorPhone/WatchConnectivityManager.swift" "$PHONE_TARGET_DIR/"

    # App ファイルは上書きしない（既存のものを使う）
    echo "  ℹ️  MotionDetectorApp.swiftは既存のものを使用します"
else
    echo "❌ エラー: $PHONE_TARGET_DIR が見つかりません"
    exit 1
fi

echo ""
echo "⌚ Apple Watchアプリファイルをコピー中..."

# Watchアプリファイルをコピー
if [ -d "$WATCH_TARGET_DIR" ]; then
    # 既存のContentView.swiftを削除
    if [ -f "$WATCH_TARGET_DIR/ContentView.swift" ]; then
        echo "  - 既存のContentView.swiftを削除"
        rm "$WATCH_TARGET_DIR/ContentView.swift"
    fi

    # 新しいファイルをコピー
    echo "  - ContentView.swiftをコピー"
    cp "MotionDetectorWatch/ContentView.swift" "$WATCH_TARGET_DIR/"

    echo "  - MotionManager.swiftをコピー"
    cp "MotionDetectorWatch/MotionManager.swift" "$WATCH_TARGET_DIR/"

    echo "  - TremorDetector.swiftをコピー"
    cp "MotionDetectorWatch/TremorDetector.swift" "$WATCH_TARGET_DIR/"

    echo "  - WatchConnectivityManager.swiftをコピー"
    cp "MotionDetectorWatch/WatchConnectivityManager.swift" "$WATCH_TARGET_DIR/"

    echo "  ℹ️  Watch Appファイルは既存のものを使用します"
else
    echo "❌ エラー: $WATCH_TARGET_DIR が見つかりません"
    exit 1
fi

echo ""
echo "✅ ファイルのコピーが完了しました！"
echo ""
echo "📋 次の手順:"
echo ""
echo "1. Xcodeに戻る"
echo ""
echo "2. 左側のProject Navigatorで「MotionDetector」フォルダを右クリック"
echo "   → 「Add Files to MotionDetector...」を選択"
echo ""
echo "3. 以下のファイルを選択（Commandキーを押しながら複数選択）:"
echo "   - ContentView.swift"
echo "   - WatchConnectivityManager.swift"
echo ""
echo "4. オプション設定:"
echo "   ✅ Copy items if needed (チェック)"
echo "   ✅ Add to targets: MotionDetector のみチェック"
echo "   → Add をクリック"
echo ""
echo "5. 「MotionDetector Watch App」フォルダを右クリック"
echo "   → 「Add Files to MotionDetector...」を選択"
echo ""
echo "6. 以下のファイルを選択:"
echo "   - ContentView.swift"
echo "   - MotionManager.swift"
echo "   - TremorDetector.swift"
echo "   - WatchConnectivityManager.swift"
echo ""
echo "7. オプション設定:"
echo "   ✅ Copy items if needed (チェック)"
echo "   ✅ Add to targets: MotionDetector Watch App のみチェック"
echo "   → Add をクリック"
echo ""
echo "🎉 完了したら、次のステップに進みます！"
