#!/bin/bash

# XcodeプロジェクトにファイルをAppleScript経由で追加

echo "🔧 Xcodeプロジェクトにファイルを自動追加します..."
echo ""

PROJECT_PATH="/Users/hikaru/00/2025/12 スマホの加速度センサ/MotionDetector/MotionDetector.xcodeproj"

# Xcodeでプロジェクトを開く
echo "📂 Xcodeプロジェクトを開いています..."
open "$PROJECT_PATH"

# Xcodeが開くまで待機
sleep 3

echo ""
echo "✅ 準備完了！"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📱 iPhoneアプリのファイル追加手順"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "1. Xcodeの左側で「MotionDetector」フォルダを見つける"
echo ""
echo "2. 以下のコマンドを実行すると、Finderが開きます："
echo ""
echo "   → フォルダが開いたら準備完了です"
echo ""

read -p "Enter キーを押すとFinderが開きます..."

open "/Users/hikaru/00/2025/12 スマホの加速度センサ/MotionDetector/MotionDetector"

echo ""
echo "3. Finderで ContentView.swift と WatchConnectivityManager.swift を選択"
echo "   （Commandキーを押しながら2つをクリック）"
echo ""
echo "4. 選択した2つのファイルを Xcode の「MotionDetector」フォルダにドラッグ"
echo ""
echo "5. ダイアログで："
echo "   ✅ Copy items if needed"
echo "   ✅ Add to targets: MotionDetector のみ"
echo "   → Finish をクリック"
echo ""

read -p "完了したら Enter キーを押してください..."

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "⌚ Watch Appのファイル追加手順"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

read -p "Enter キーを押すとFinderが開きます..."

open "/Users/hikaru/00/2025/12 スマホの加速度センサ/MotionDetector/MotionDetector Watch App"

echo ""
echo "1. Finderで全ての.swiftファイル（4つ）を選択"
echo "   （Command + A で全選択）"
echo ""
echo "2. Xcode の「MotionDetector Watch App」フォルダにドラッグ"
echo ""
echo "3. ダイアログで："
echo "   ✅ Copy items if needed"
echo "   ✅ Add to targets: MotionDetector Watch App のみ"
echo "   → Finish をクリック"
echo ""

read -p "完了したら Enter キーを押してください..."

echo ""
echo "🎉 完了しました！"
echo ""
echo "次は権限の設定に進みます。"
