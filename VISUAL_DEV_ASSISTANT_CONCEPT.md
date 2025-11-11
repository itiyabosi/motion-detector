# Visual Dev Assistant - プロダクト構想書

**日付**: 2025年11月11日
**ステータス**: コンセプト段階
**背景**: モーション判定アプリ開発中に発見した課題から着想

---

## 目次

1. [エグゼクティブサマリー](#エグゼクティブサマリー)
2. [解決する課題](#解決する課題)
3. [プロダクトコンセプト](#プロダクトコンセプト)
4. [技術仕様](#技術仕様)
5. [実装ロードマップ](#実装ロードマップ)
6. [ビジネスモデル](#ビジネスモデル)
7. [市場分析](#市場分析)
8. [技術的課題と解決策](#技術的課題と解決策)

---

## エグゼクティブサマリー

### プロダクト名
**Visual Dev Assistant** (仮称)
**別名候補**: GUI Pointer, DevVision, VisualGuide

### ワンライナー
> AI開発アシスタントが、ユーザーのMac画面をキャプチャして、GUI上で次の操作を視覚的に提案する開発支援ツール

### 解決する問題
プログラミング初心者やリモート開発者が、複雑な開発ツール（Xcode、VS Code等）の操作方法をテキストだけで理解するのは困難。「どこをクリックするか」「どのボタンか」を視覚的に示せれば、学習効率が劇的に向上する。

### ターゲット市場
- プログラミング学習者（年間数百万人）
- 技術サポート担当者
- オンライン教育プラットフォーム
- 企業の開発チーム（オンボーディング）

### 収益予測（Year 1）
- Freemiumモデル: 月額$9.99
- 想定コンバージョン率: 5%
- 10万ユーザー獲得で → 年間$600K ARR

---

## 解決する課題

### 課題の発見経緯

**2025年11月11日 - Apple Watchアプリ開発中**

```
開発者（Claude）: 「画面上部の再生ボタンの左側を見てください」
ユーザー: 「再生ボタンの左？」
開発者: 「...（テキストでは説明が困難）」
```

このやり取りから、**テキストベース説明の根本的な限界**が明らかになった。

### 課題の詳細分析

#### 問題1: 位置の説明が困難

**テキスト説明の例**:
```
「Xcodeの画面上部、左から3番目のツールバーボタン、
再生ボタンの左側にあるドロップダウンメニューをクリック」
```

**課題**:
- 「上部」「左側」は相対的で曖昧
- ユーザーの画面レイアウトが異なる可能性
- バージョン違いでUI配置が変わる
- 多言語環境での表示名の違い

**あるべき姿**:
```
[スクリーンショット]
     ↓ 赤い矢印
[ここをクリック]
```

#### 問題2: 操作手順の複雑さ

**複雑な操作の例（Xcodeでのファイル追加）**:
```
1. 左側のProject Navigator（フォルダアイコン）を開く
2. MotionDetectorフォルダを右クリック
3. コンテキストメニューから"Add Files to..."を選択
4. ファイル選択ダイアログが開く
5. Commandキーを押しながら複数ファイルを選択
6. "Add to targets"でMotionDetectorにチェック
7. Finishボタンをクリック
```

**課題**:
- 7つのステップを全てテキストで説明
- 各ステップでの視覚的確認ができない
- ユーザーが迷子になりやすい
- 途中で間違えても気づけない

**あるべき姿**:
```
[ステップ1の画像]
① ここをクリック
   ↓ 完了確認
[ステップ2の画像]
② 次にここ
   ↓ 完了確認
...
```

#### 問題3: 視覚情報の欠如

**テキストで表現困難な要素**:
- ボタンの色・形状・アイコン
- メニュー階層の構造
- UI要素の視覚的な区別
- 画面全体の文脈

**例**:
```
テキスト: "緑色の再生ボタン"
実際: 複数の緑色ボタンが存在
     どれを指しているか不明確
```

#### 問題4: コンテキストの不一致

**開発者の想定とユーザーの現実のギャップ**:

| 開発者の想定 | ユーザーの実際 |
|------------|-------------|
| Xcodeが開いている | 別のウィンドウが前面に |
| デフォルトレイアウト | カスタマイズ済み |
| 最新版 | 古いバージョン |
| エラーなし | エラー状態 |

---

## プロダクトコンセプト

### コアアイデア

```
┌────────────────────┐
│ ユーザーの質問     │
│ "どこをクリック？"  │
└─────────┬──────────┘
          │
          ↓
┌────────────────────────────┐
│ Visual Dev Assistant       │
│ 1. 画面をキャプチャ         │
│ 2. UI要素を自動検出         │
│ 3. 操作箇所を特定           │
│ 4. 矢印・ハイライトで可視化  │
└─────────┬──────────────────┘
          │
          ↓
┌────────────────────────────┐
│ [注釈付き画像を表示]        │
│  ┌──────────────┐          │
│  │   Xcode      │          │
│  │   ┌─────┐   │          │
│  │   │Build│←①ここ       │
│  │   └─────┘   │          │
│  └──────────────┘          │
└────────────────────────────┘
```

### 主要機能

#### 機能1: スマートスクリーンキャプチャ

**特徴**:
- アプリケーション単位でキャプチャ
- アクティブウィンドウの自動検出
- 高解像度・Retinaディスプレイ対応
- プライバシー保護（選択エリアのみ）

**技術**:
- macOS: ScreenCaptureKit
- Windows: Windows.Graphics.Capture API
- Linux: X11/Wayland capture

**ユーザーフロー**:
```
ユーザー: "Xcodeのビルドボタンどこ？"
    ↓
システム: Xcodeウィンドウを自動検出
    ↓
システム: スクリーンキャプチャ実行
    ↓
次の処理へ
```

#### 機能2: AI駆動UI要素検出

**検出対象**:
- ボタン（位置、テキスト、アイコン）
- メニュー項目
- 入力フィールド
- ドロップダウン
- タブ
- ツールバーアイテム

**検出技術の組み合わせ**:

```
┌─────────────────────────────────┐
│ マルチモーダル検出エンジン        │
├─────────────────────────────────┤
│ 1. OCR (テキスト認識)            │
│    - Tesseract / Apple Vision   │
│    - ボタンラベル、メニュー項目   │
│                                  │
│ 2. エッジ検出 (形状認識)          │
│    - OpenCV Canny                │
│    - ボタン輪郭、ウィンドウ境界   │
│                                  │
│ 3. 色検出 (視覚的特徴)            │
│    - HSV色空間分析               │
│    - ボタン色、アクティブ状態    │
│                                  │
│ 4. 機械学習 (パターン認識)        │
│    - YOLOv8 / ResNet            │
│    - UI要素の意味的理解          │
└─────────────────────────────────┘
        ↓
┌─────────────────────────────────┐
│ 統合判定エンジン                 │
│ - 信頼度スコアリング              │
│ - 複数検出結果の融合              │
│ - コンテキスト考慮                │
└─────────────────────────────────┘
```

**出力例**:
```json
{
  "elements": [
    {
      "type": "button",
      "text": "Build",
      "bbox": [100, 50, 150, 80],
      "confidence": 0.95,
      "context": "toolbar",
      "actionable": true
    },
    {
      "type": "menu",
      "text": "Product",
      "bbox": [20, 10, 80, 30],
      "confidence": 0.98,
      "has_submenu": true
    }
  ]
}
```

#### 機能3: インテリジェント注釈生成

**注釈タイプ**:

1. **矢印（Arrow）**
   - 開始点: 画面外または空白エリア
   - 終点: ターゲットUI要素
   - スタイル: 太い赤線、先端に円形

2. **ハイライト（Highlight）**
   - 黄色の半透明矩形
   - ターゲット要素を囲む
   - パルスアニメーション（オプション）

3. **ステップ番号（Step Number）**
   - 大きな数字バッジ
   - 複数ステップの順序表示
   - 色分け（進行状況）

4. **説明テキスト（Description Text）**
   - 吹き出し形式
   - 操作の簡潔な説明
   - アイコン付き

**ビジュアル例**:
```
┌──────────────────────────────────┐
│  Xcode                    [x]    │
├──────────────────────────────────┤
│ File Edit View ...        [①] ←─┐
│  ┌────────────────────┐    │     │
│  │ Project Navigator  │    │     │ "ここをクリック"
│  │  📁 MotionDetector │    │     │
│  │  📄 ContentView    │◄──[②]   │
│  └────────────────────┘    │     │
│                            │     │
│  [Editor Area]             │     │
│                            │     │
└────────────────────────────┴─────┘
```

#### 機能4: ステップバイステップガイド

**機能概要**:
複雑な操作を自動的に分解し、各ステップを順次表示

**フロー**:
```
[ステップ1: ファイルメニューを開く]
    画像表示 + 注釈
    ↓ ユーザーが実行
    ↓ 検出: メニューが開いた
    ✓ 完了

[ステップ2: "Open"を選択]
    画像更新 + 新しい注釈
    ↓ ユーザーが実行
    ↓ 検出: ダイアログが開いた
    ✓ 完了

[ステップ3: ファイルを選択]
    ...
```

**完了検出方法**:
- 画面変化の検出（差分比較）
- UI要素の状態変化
- ユーザーの明示的な確認
- タイムアウト（スキップ）

#### 機能5: Claude Code統合

**統合アーキテクチャ**:
```
┌─────────────────────────────────┐
│ Claude Code CLI                 │
│ (既存のAI開発アシスタント)        │
└──────────┬──────────────────────┘
           │ Tool API
           ↓
┌─────────────────────────────────┐
│ Visual Dev Assistant            │
│ (新規ツール)                     │
│                                  │
│ show_visual_guide(               │
│   instruction="Click Build",    │
│   app="Xcode"                   │
│ )                                │
└──────────┬──────────────────────┘
           │
           ↓
    [注釈付き画像を返却]
```

**使用例**:

**Before (テキストのみ)**:
```
Claude: Xcodeの画面上部にある再生ボタンの左側の
        ドロップダウンメニューをクリックして、
        "MotionDetector Watch App"を選択してください。
User: ？？？
```

**After (Visual Dev Assistant)**:
```
Claude: ビルド先を変更しましょう。
[Tool: show_visual_guide]
User: [画像を見る]
      → 一目瞭然！
```

---

## 技術仕様

### システムアーキテクチャ

```
┌────────────────────────────────────────────────┐
│           User Interface Layer                 │
│  ┌──────────────┬──────────────┬────────────┐ │
│  │ Terminal     │ Web Viewer   │ Overlay    │ │
│  │ (iTerm2 etc) │ (Browser)    │ (macOS)    │ │
│  └──────────────┴──────────────┴────────────┘ │
└────────────────────┬───────────────────────────┘
                     │
┌────────────────────┴───────────────────────────┐
│           API / Integration Layer              │
│  ┌──────────────────────────────────────────┐ │
│  │ Claude Code Tool Protocol                │ │
│  │ - Tool registration                      │ │
│  │ - JSON-RPC communication                 │ │
│  │ - Image encoding/decoding                │ │
│  └──────────────────────────────────────────┘ │
└────────────────────┬───────────────────────────┘
                     │
┌────────────────────┴───────────────────────────┐
│         Visual Dev Assistant Core              │
│  ┌──────────────────────────────────────────┐ │
│  │ Orchestrator                             │ │
│  │ - Workflow management                    │ │
│  │ - State tracking                         │ │
│  │ - Error handling                         │ │
│  └──────────────────────────────────────────┘ │
└────────────────────┬───────────────────────────┘
                     │
        ┌────────────┼────────────┐
        │            │            │
┌───────┴──────┐ ┌──┴────────┐ ┌┴──────────────┐
│ Capture      │ │ Analysis  │ │ Rendering     │
│ Module       │ │ Module    │ │ Module        │
│              │ │           │ │               │
│ - Screen     │ │ - OCR     │ │ - Annotation  │
│   capture    │ │ - Edge    │ │ - Arrow       │
│ - Window     │ │   detect  │ │ - Highlight   │
│   detection  │ │ - Color   │ │ - Text        │
│ - Area       │ │   detect  │ │ - Layout      │
│   selection  │ │ - ML      │ │               │
└──────────────┘ └───────────┘ └───────────────┘
```

### 技術スタック比較

#### Option 1: Python + macOS Native API

**技術構成**:
```python
- PyObjC: macOS API binding
- Pillow/OpenCV: Image processing
- pytesseract: OCR engine
- PyQt6/Tkinter: GUI/Overlay
- FastAPI: REST API (optional)
```

**長所**:
- ✅ 迅速なプロトタイピング
- ✅ 豊富なライブラリエコシステム
- ✅ Claude Codeとの統合が容易（Python同士）
- ✅ 機械学習ライブラリ（PyTorch, TensorFlow）
- ✅ 開発コストが低い

**短所**:
- ❌ パフォーマンス（特にリアルタイム処理）
- ❌ 配布の複雑さ（依存関係）
- ❌ バイナリサイズが大きい
- ❌ macOS統合が完全ではない

**推奨ユースケース**:
- MVP開発
- プロトタイプ検証
- 研究・実験

**開発期間**: 2-3週間（MVP）

---

#### Option 2: Swift (macOS Native)

**技術構成**:
```swift
- ScreenCaptureKit: High-perf capture (macOS 12.3+)
- Vision Framework: OCR & object detection
- Core Graphics: Image processing
- Core Image: Filters & effects
- SwiftUI/AppKit: Native UI
- Combine: Reactive programming
```

**長所**:
- ✅ ネイティブパフォーマンス
- ✅ macOS完全統合
- ✅ App Store配布可能
- ✅ 最新API活用
- ✅ メモリ効率が良い
- ✅ セキュリティ・プライバシー対応

**短所**:
- ❌ 開発時間がかかる
- ❌ macOS専用（クロスプラットフォーム不可）
- ❌ Claude Code統合に工夫が必要
- ❌ 学習曲線

**推奨ユースケース**:
- プロダクション版
- App Store公開
- 長期運用

**開発期間**: 6-8週間（本格版）

---

#### Option 3: Electron (Cross-Platform)

**技術構成**:
```javascript
- Electron: Desktop app framework
- node-screenshots: Cross-platform capture
- Tesseract.js: OCR
- Sharp: Image processing
- Canvas/Fabric.js: Annotation rendering
- React: UI framework
```

**長所**:
- ✅ クロスプラットフォーム（Mac/Windows/Linux）
- ✅ Web技術活用（開発効率）
- ✅ 豊富なnpmエコシステム
- ✅ Hot reloadで開発効率UP
- ✅ UI開発が容易

**短所**:
- ❌ 大きなバイナリサイズ（100MB+）
- ❌ メモリ使用量が多い
- ❌ パフォーマンス（Pythonよりは良い）
- ❌ ネイティブAPI制限

**推奨ユースケース**:
- クロスプラットフォーム展開
- 既存Web技術の活用
- 大規模ユーザーベース

**開発期間**: 4-6週間

---

### 推奨アプローチ: ハイブリッド戦略

```
Phase 1 (MVP): Python版
  ↓ 2-3週間
検証・フィードバック収集
  ↓
Phase 2 (Production): Swift版
  ↓ 6-8週間
macOS完全版リリース
  ↓
Phase 3 (拡大): Electron版
  ↓ 4-6週間
Windows/Linux対応
```

---

### コア機能の実装例

#### 1. スクリーンキャプチャ実装

**Python版 (PyObjC)**:
```python
import Quartz
from Cocoa import NSBitmapImageRep
from PIL import Image
import numpy as np

class ScreenCapture:
    def capture_window(self, app_name="Xcode"):
        """特定アプリのウィンドウをキャプチャ"""

        # 全ウィンドウ情報を取得
        window_list = Quartz.CGWindowListCopyWindowInfo(
            Quartz.kCGWindowListOptionOnScreenOnly,
            Quartz.kCGNullWindowID
        )

        # 目的のアプリを検索
        target_window = None
        for window in window_list:
            owner_name = window.get('kCGWindowOwnerName', '')
            if app_name in owner_name:
                target_window = window
                break

        if not target_window:
            raise ValueError(f"{app_name} window not found")

        # ウィンドウの位置とサイズを取得
        bounds = target_window['kCGWindowBounds']
        x, y = bounds['X'], bounds['Y']
        width, height = bounds['Width'], bounds['Height']

        # 画面をキャプチャ
        region = Quartz.CGRectMake(x, y, width, height)
        image_ref = Quartz.CGWindowListCreateImage(
            region,
            Quartz.kCGWindowListOptionIncludingWindow,
            target_window['kCGWindowNumber'],
            Quartz.kCGWindowImageBoundsIgnoreFraming
        )

        # PIL Imageに変換
        width = Quartz.CGImageGetWidth(image_ref)
        height = Quartz.CGImageGetHeight(image_ref)
        bytes_per_row = Quartz.CGImageGetBytesPerRow(image_ref)
        data_provider = Quartz.CGImageGetDataProvider(image_ref)
        pixel_data = Quartz.CGDataProviderCopyData(data_provider)

        image_array = np.frombuffer(pixel_data, dtype=np.uint8)
        image_array = image_array.reshape((height, bytes_per_row // 4, 4))
        image_array = image_array[:, :width, :3]  # BGRA -> RGB

        return Image.fromarray(image_array)
```

**Swift版 (ScreenCaptureKit)**:
```swift
import ScreenCaptureKit
import CoreImage

class ScreenCapture {
    func captureWindow(appName: String) async throws -> CIImage {
        // 利用可能なコンテンツを取得
        let content = try await SCShareableContent.current

        // 目的のアプリのウィンドウを検索
        guard let window = content.windows.first(where: {
            $0.owningApplication?.applicationName == appName
        }) else {
            throw CaptureError.windowNotFound
        }

        // キャプチャ設定
        let config = SCStreamConfiguration()
        config.width = Int(window.frame.width * 2) // Retina対応
        config.height = Int(window.frame.height * 2)
        config.showsCursor = false

        // フィルター作成（特定ウィンドウのみ）
        let filter = SCContentFilter(
            desktopIndependentWindow: window
        )

        // キャプチャ実行
        let image = try await SCScreenshotManager.captureImage(
            contentFilter: filter,
            configuration: config
        )

        return CIImage(cgImage: image)
    }
}
```

#### 2. UI要素検出実装

**Python版 (OCR + CV)**:
```python
import cv2
import pytesseract
from PIL import Image
import numpy as np

class UIElementDetector:
    def __init__(self):
        self.min_button_width = 30
        self.max_button_width = 300
        self.min_button_height = 20
        self.max_button_height = 60

    def detect_elements(self, image):
        """画像からUI要素を検出"""
        elements = []

        # 1. OCRでテキスト要素を検出
        text_elements = self._detect_text_elements(image)
        elements.extend(text_elements)

        # 2. エッジ検出でボタンを検出
        button_elements = self._detect_buttons(image)
        elements.extend(button_elements)

        # 3. 色検出でアクティブ要素を検出
        active_elements = self._detect_active_elements(image)
        elements.extend(active_elements)

        # 4. 重複を除去・統合
        elements = self._merge_overlapping_elements(elements)

        return elements

    def _detect_text_elements(self, image):
        """OCRでテキスト要素を検出"""
        # Tesseract OCR実行
        ocr_data = pytesseract.image_to_data(
            image,
            output_type=pytesseract.Output.DICT,
            config='--psm 11'  # Sparse text mode
        )

        elements = []
        for i in range(len(ocr_data['text'])):
            text = ocr_data['text'][i].strip()
            if not text or ocr_data['conf'][i] < 60:
                continue

            element = {
                'type': 'text',
                'text': text,
                'bbox': (
                    ocr_data['left'][i],
                    ocr_data['top'][i],
                    ocr_data['width'][i],
                    ocr_data['height'][i]
                ),
                'confidence': ocr_data['conf'][i] / 100.0
            }
            elements.append(element)

        return elements

    def _detect_buttons(self, image):
        """エッジ検出でボタンを検出"""
        # グレースケール変換
        gray = cv2.cvtColor(np.array(image), cv2.COLOR_RGB2GRAY)

        # エッジ検出
        edges = cv2.Canny(gray, 50, 150)

        # 輪郭検出
        contours, _ = cv2.findContours(
            edges,
            cv2.RETR_EXTERNAL,
            cv2.CHAIN_APPROX_SIMPLE
        )

        elements = []
        for contour in contours:
            x, y, w, h = cv2.boundingRect(contour)

            # ボタンらしいサイズかチェック
            if (self.min_button_width < w < self.max_button_width and
                self.min_button_height < h < self.max_button_height):

                # 矩形度をチェック（ボタンは矩形に近い）
                area = cv2.contourArea(contour)
                rect_area = w * h
                if area / rect_area > 0.7:  # 70%以上が矩形
                    element = {
                        'type': 'button',
                        'bbox': (x, y, w, h),
                        'confidence': 0.7
                    }
                    elements.append(element)

        return elements

    def _detect_active_elements(self, image):
        """色検出でアクティブな要素を検出"""
        # HSV色空間に変換
        hsv = cv2.cvtColor(np.array(image), cv2.COLOR_RGB2HSV)

        # 青色範囲（macOSのアクティブボタン）
        lower_blue = np.array([100, 50, 50])
        upper_blue = np.array([130, 255, 255])
        blue_mask = cv2.inRange(hsv, lower_blue, upper_blue)

        # 緑色範囲（実行ボタン）
        lower_green = np.array([40, 50, 50])
        upper_green = np.array([80, 255, 255])
        green_mask = cv2.inRange(hsv, lower_green, upper_green)

        # マスクを統合
        combined_mask = cv2.bitwise_or(blue_mask, green_mask)

        # 輪郭検出
        contours, _ = cv2.findContours(
            combined_mask,
            cv2.RETR_EXTERNAL,
            cv2.CHAIN_APPROX_SIMPLE
        )

        elements = []
        for contour in contours:
            x, y, w, h = cv2.boundingRect(contour)
            if w > 10 and h > 10:  # 最小サイズ
                element = {
                    'type': 'active',
                    'bbox': (x, y, w, h),
                    'confidence': 0.6
                }
                elements.append(element)

        return elements

    def _merge_overlapping_elements(self, elements):
        """重複する要素を統合"""
        if not elements:
            return []

        # IoU（Intersection over Union）で重複判定
        def calculate_iou(box1, box2):
            x1, y1, w1, h1 = box1
            x2, y2, w2, h2 = box2

            xi1 = max(x1, x2)
            yi1 = max(y1, y2)
            xi2 = min(x1 + w1, x2 + w2)
            yi2 = min(y1 + h1, y2 + h2)

            inter_area = max(0, xi2 - xi1) * max(0, yi2 - yi1)
            box1_area = w1 * h1
            box2_area = w2 * h2
            union_area = box1_area + box2_area - inter_area

            return inter_area / union_area if union_area > 0 else 0

        merged = []
        used = set()

        for i, elem1 in enumerate(elements):
            if i in used:
                continue

            # テキスト要素を優先
            current = elem1.copy()

            for j, elem2 in enumerate(elements[i+1:], i+1):
                if j in used:
                    continue

                iou = calculate_iou(elem1['bbox'], elem2['bbox'])
                if iou > 0.5:  # 50%以上重複
                    # テキスト情報を優先して統合
                    if 'text' in elem2 and 'text' not in current:
                        current['text'] = elem2['text']
                    current['confidence'] = max(
                        current['confidence'],
                        elem2['confidence']
                    )
                    used.add(j)

            merged.append(current)
            used.add(i)

        return merged
```

#### 3. 注釈描画実装

**Python版 (Pillow)**:
```python
from PIL import Image, ImageDraw, ImageFont
import math

class AnnotationRenderer:
    def __init__(self):
        self.arrow_color = (255, 0, 0)  # 赤
        self.highlight_color = (255, 255, 0, 128)  # 半透明黄色
        self.text_color = (255, 255, 255)  # 白
        self.text_bg_color = (0, 0, 0, 180)  # 半透明黒

        # フォント設定
        try:
            self.font = ImageFont.truetype(
                '/System/Library/Fonts/Helvetica.ttc',
                size=24
            )
            self.font_large = ImageFont.truetype(
                '/System/Library/Fonts/Helvetica.ttc',
                size=48
            )
        except:
            self.font = ImageFont.load_default()
            self.font_large = ImageFont.load_default()

    def annotate(self, image, instruction):
        """
        画像に注釈を追加

        instruction = {
            'step': 1,
            'target_bbox': (100, 50, 150, 80),
            'arrow_start': 'top-left',  # or custom (x, y)
            'description': 'Click here',
            'highlight': True
        }
        """
        # RGBA modeに変換（透明度対応）
        if image.mode != 'RGBA':
            image = image.convert('RGBA')

        # オーバーレイ用のレイヤー作成
        overlay = Image.new('RGBA', image.size, (0, 0, 0, 0))
        draw = ImageDraw.Draw(overlay)

        # 1. ハイライトを描画
        if instruction.get('highlight'):
            self._draw_highlight(draw, instruction['target_bbox'])

        # 2. 矢印を描画
        self._draw_arrow(
            draw,
            instruction.get('arrow_start', 'top-left'),
            instruction['target_bbox']
        )

        # 3. ステップ番号を描画
        if 'step' in instruction:
            self._draw_step_number(
                draw,
                instruction['step'],
                instruction['target_bbox']
            )

        # 4. 説明テキストを描画
        if 'description' in instruction:
            self._draw_description(
                draw,
                instruction['description'],
                instruction['target_bbox']
            )

        # オーバーレイを合成
        return Image.alpha_composite(image, overlay)

    def _draw_highlight(self, draw, bbox):
        """ハイライト矩形を描画"""
        x, y, w, h = bbox
        # 少し大きめに描画（パディング）
        padding = 5
        draw.rectangle(
            [
                (x - padding, y - padding),
                (x + w + padding, y + h + padding)
            ],
            fill=self.highlight_color,
            outline=(255, 255, 0, 255),
            width=3
        )

    def _draw_arrow(self, draw, start, target_bbox):
        """矢印を描画"""
        tx, ty, tw, th = target_bbox
        target_center = (tx + tw // 2, ty + th // 2)

        # 始点を計算
        if isinstance(start, str):
            if start == 'top-left':
                start_point = (tx - 80, ty - 80)
            elif start == 'top-right':
                start_point = (tx + tw + 80, ty - 80)
            elif start == 'left':
                start_point = (tx - 80, target_center[1])
            else:
                start_point = (tx - 80, ty - 80)
        else:
            start_point = start

        # 矢印本体（太い線）
        draw.line(
            [start_point, target_center],
            fill=self.arrow_color,
            width=6
        )

        # 矢印の先端（三角形）
        self._draw_arrow_head(
            draw,
            start_point,
            target_center,
            size=20
        )

        # 始点の円
        r = 8
        draw.ellipse(
            [
                (start_point[0] - r, start_point[1] - r),
                (start_point[0] + r, start_point[1] + r)
            ],
            fill=self.arrow_color
        )

    def _draw_arrow_head(self, draw, start, end, size=20):
        """矢印の先端を描画"""
        # 角度を計算
        dx = end[0] - start[0]
        dy = end[1] - start[1]
        angle = math.atan2(dy, dx)

        # 三角形の3点を計算
        angle1 = angle + math.pi * 5 / 6
        angle2 = angle - math.pi * 5 / 6

        p1 = end
        p2 = (
            end[0] + size * math.cos(angle1),
            end[1] + size * math.sin(angle1)
        )
        p3 = (
            end[0] + size * math.cos(angle2),
            end[1] + size * math.sin(angle2)
        )

        draw.polygon([p1, p2, p3], fill=self.arrow_color)

    def _draw_step_number(self, draw, step, bbox):
        """ステップ番号を描画"""
        x, y, w, h = bbox

        # 位置（左上）
        pos = (x - 60, y - 60)

        # 背景円
        radius = 30
        draw.ellipse(
            [
                (pos[0] - radius, pos[1] - radius),
                (pos[0] + radius, pos[1] + radius)
            ],
            fill=(255, 0, 0, 255),
            outline=(255, 255, 255, 255),
            width=3
        )

        # 番号テキスト
        text = str(step)
        bbox = draw.textbbox((0, 0), text, font=self.font_large)
        text_width = bbox[2] - bbox[0]
        text_height = bbox[3] - bbox[1]

        text_pos = (
            pos[0] - text_width // 2,
            pos[1] - text_height // 2
        )

        draw.text(
            text_pos,
            text,
            fill=(255, 255, 255, 255),
            font=self.font_large
        )

    def _draw_description(self, draw, text, bbox):
        """説明テキストを描画"""
        x, y, w, h = bbox

        # テキストサイズを計算
        text_bbox = draw.textbbox((0, 0), text, font=self.font)
        text_width = text_bbox[2] - text_bbox[0]
        text_height = text_bbox[3] - text_bbox[1]

        # 吹き出しの位置（要素の下）
        bubble_x = x + w // 2 - text_width // 2 - 10
        bubble_y = y + h + 20
        bubble_width = text_width + 20
        bubble_height = text_height + 20

        # 吹き出しの背景
        draw.rectangle(
            [
                (bubble_x, bubble_y),
                (bubble_x + bubble_width, bubble_y + bubble_height)
            ],
            fill=self.text_bg_color,
            outline=(255, 255, 255, 255),
            width=2
        )

        # 吹き出しの尖り（三角形）
        triangle_tip = (x + w // 2, y + h + 10)
        triangle = [
            triangle_tip,
            (triangle_tip[0] - 10, bubble_y),
            (triangle_tip[0] + 10, bubble_y)
        ]
        draw.polygon(triangle, fill=self.text_bg_color)

        # テキスト
        draw.text(
            (bubble_x + 10, bubble_y + 10),
            text,
            fill=self.text_color,
            font=self.font
        )
```

#### 4. Claude Code統合

**Tool定義**:
```python
from typing import Dict, Any, Optional
import base64
from io import BytesIO

class VisualGuideTool:
    """Claude Code Tool for visual guidance"""

    name = "show_visual_guide"
    description = """
    Show visual guide for GUI operations.
    Captures the screen, detects UI elements, and annotates
    the target action with arrows and highlights.
    """

    parameters = {
        "instruction": {
            "type": "string",
            "description": "What action to show (e.g., 'Click Build button')",
            "required": True
        },
        "app_name": {
            "type": "string",
            "description": "Target application name (e.g., 'Xcode')",
            "required": False,
            "default": None
        },
        "highlight": {
            "type": "boolean",
            "description": "Whether to highlight the target element",
            "required": False,
            "default": True
        },
        "step": {
            "type": "integer",
            "description": "Step number for multi-step guides",
            "required": False,
            "default": None
        }
    }

    def __init__(self):
        self.capture = ScreenCapture()
        self.detector = UIElementDetector()
        self.renderer = AnnotationRenderer()
        self.claude_api = ClaudeAPIClient()  # For parsing

    async def execute(
        self,
        instruction: str,
        app_name: Optional[str] = None,
        highlight: bool = True,
        step: Optional[int] = None
    ) -> Dict[str, Any]:
        """
        Execute visual guide generation

        Returns:
            {
                'success': bool,
                'image': str (base64 encoded),
                'message': str
            }
        """
        try:
            # 1. 画面をキャプチャ
            if app_name:
                screenshot = self.capture.capture_window(app_name)
            else:
                screenshot = self.capture.capture_screen()

            # 2. UI要素を検出
            elements = self.detector.detect_elements(screenshot)

            # 3. 指示を解析してターゲット要素を特定
            target = await self._find_target_element(
                instruction,
                elements
            )

            if not target:
                return {
                    'success': False,
                    'message': f"Could not find target for: {instruction}"
                }

            # 4. 注釈を追加
            annotation_config = {
                'target_bbox': target['bbox'],
                'highlight': highlight,
                'description': instruction,
                'step': step
            }

            annotated = self.renderer.annotate(
                screenshot,
                annotation_config
            )

            # 5. 画像をbase64エンコード
            buffered = BytesIO()
            annotated.save(buffered, format="PNG")
            img_str = base64.b64encode(buffered.getvalue()).decode()

            return {
                'success': True,
                'image': img_str,
                'message': f"Visual guide for: {instruction}",
                'target': target
            }

        except Exception as e:
            return {
                'success': False,
                'message': f"Error: {str(e)}"
            }

    async def _find_target_element(
        self,
        instruction: str,
        elements: list
    ) -> Optional[Dict[str, Any]]:
        """Claude APIで指示を解析し、ターゲット要素を特定"""

        # Claude APIに問い合わせ
        prompt = f"""
        Given this instruction: "{instruction}"
        And these detected UI elements:
        {self._format_elements_for_claude(elements)}

        Identify which element the user should interact with.
        Return JSON with:
        {{
            "element_index": <int>,
            "confidence": <float>,
            "reasoning": "<string>"
        }}
        """

        response = await self.claude_api.complete(prompt)
        result = json.loads(response)

        if result['element_index'] >= 0:
            return elements[result['element_index']]

        return None

    def _format_elements_for_claude(self, elements: list) -> str:
        """要素リストをClaude用にフォーマット"""
        formatted = []
        for i, elem in enumerate(elements):
            formatted.append(
                f"{i}: type={elem['type']}, "
                f"bbox={elem['bbox']}, "
                f"text={elem.get('text', 'N/A')}, "
                f"confidence={elem['confidence']:.2f}"
            )
        return "\n".join(formatted)
```

**使用例（Claude Code内）**:
```python
# Claude Codeの会話フロー内

User: "Xcodeのビルドボタンがどこにあるかわかりません"

Claude: "画面を確認して、視覚的にお見せしますね。"

# Toolを実行
result = await tools.show_visual_guide(
    instruction="Click the Build button",
    app_name="Xcode",
    highlight=True,
    step=1
)

if result['success']:
    # 画像を表示（ターミナルまたはブラウザ）
    display_image(result['image'])

    Claude: """
    ビルドボタンはこちらです！
    画面上部のツールバー、再生ボタンの形をしています。
    """
else:
    Claude: f"申し訳ありません。{result['message']}"
```

---

## 実装ロードマップ

### Phase 1: MVP (Minimum Viable Product)

**期間**: 2-3週間
**技術**: Python + PyObjC
**目標**: 基本的な視覚ガイド機能を実証

#### 実装内容

**Week 1**:
- [x] プロジェクトセットアップ
- [x] スクリーンキャプチャ機能
  - macOS全画面キャプチャ
  - 特定ウィンドウキャプチャ
- [x] 基本的なOCR統合
  - pytesseract導入
  - テキスト要素検出

**Week 2**:
- [ ] シンプルな矢印描画
  - Pillow使用
  - 固定位置への矢印
- [ ] コマンドラインインターフェース
  ```bash
  python visual_guide.py --instruction "Click Build" --app "Xcode"
  ```
- [ ] 画像出力（PNG保存）

**Week 3**:
- [ ] 基本的なUI要素検出
  - エッジ検出でボタン識別
  - OCRとの組み合わせ
- [ ] テスト・デバッグ
- [ ] ドキュメント作成

#### 成功基準

**必須**:
- ✅ Xcodeのビルドボタンを検出して矢印を表示できる
- ✅ 3つの異なるアプリで動作確認
- ✅ 基本的なエラーハンドリング

**オプション**:
- ⚠️ 複数ステップのガイド
- ⚠️ インタラクティブ性

#### デモシナリオ

```
$ python visual_guide.py \
    --instruction "Click the Build button" \
    --app "Xcode" \
    --output demo.png

Capturing Xcode window...
Detecting UI elements...
Found 15 elements
Identifying target...
Target found: Build button (confidence: 0.92)
Rendering annotation...
Saved to: demo.png

$ open demo.png
[ビルドボタンに赤い矢印が表示された画像が開く]
```

---

### Phase 2: UI要素検出強化

**期間**: 2-4週間
**目標**: より正確で多様なUI要素検出

#### 実装内容

**Week 4-5**:
- [ ] マルチモーダル検出
  - OCR改善（Apple Vision Frameworkも試行）
  - エッジ検出の精度向上
  - 色検出追加
- [ ] アプリケーション固有の学習
  - Xcode専用の検出ルール
  - VS Code専用の検出ルール
  - ブラウザ専用の検出ルール

**Week 6-7**:
- [ ] 機械学習モデルの導入（オプション）
  - YOLOv8でボタン検出
  - Rico datasetでの事前学習
- [ ] コンテキスト理解
  - メニュー階層の理解
  - UI状態の検出（有効/無効）

#### 成功基準

- ✅ 検出精度90%以上（手動評価）
- ✅ 10種類以上のUI要素タイプに対応
- ✅ 誤検出率10%以下

---

### Phase 3: インタラクティブ機能

**期間**: 4-6週間
**目標**: リアルタイム・インタラクティブなガイドシステム

#### 実装内容

**Week 8-10**:
- [ ] オーバーレイウィンドウ
  - 透明ウィンドウをアプリ上に表示
  - クリックスルー対応
- [ ] リアルタイム追従
  - ウィンドウ移動の検出
  - 継続的な再描画
- [ ] ステップ完了検出
  - 画面変化の検出
  - ユーザーアクションの確認

**Week 11-13**:
- [ ] マルチステップガイド
  - ウィザード形式のUI
  - 進行状況表示
- [ ] 音声ガイド（オプション）
  - Text-to-Speech統合
  - 音声での操作説明
- [ ] 動画キャプチャ
  - 操作手順の自動録画
  - GIF/MP4出力

#### 成功基準

- ✅ リアルタイム表示（30fps以上）
- ✅ 複雑な10ステップの操作をガイド可能
- ✅ ユーザーテストで80%以上が「分かりやすい」と評価

---

### Phase 4: Claude Code統合・プロダクション化

**期間**: 2-3週間
**目標**: Claude Codeツールとして正式リリース

#### 実装内容

- [ ] Claude Code Tool Protocol実装
- [ ] APIインターフェース確定
- [ ] パフォーマンス最適化
- [ ] エラーハンドリング強化
- [ ] セキュリティ・プライバシー対策
- [ ] パッケージング・配布

#### リリース基準

- ✅ Claude Code公式ドキュメントに記載
- ✅ macOS 12.0以降で動作
- ✅ インストール所要時間5分以内
- ✅ 平均レスポンス時間2秒以内

---

## ビジネスモデル

### ターゲットユーザー

#### セグメント1: プログラミング初心者

**ペルソナ**:
- 名前: 田中太郎（25歳）
- 職業: Webデザイナー → 開発者へ転向中
- 課題: IDEの使い方がわからず、チュートリアルを見ても迷う
- ニーズ: 「どこをクリックするか」視覚的に教えて欲しい

**市場規模**:
- 日本のプログラミングスクール受講者: 年間10万人
- 世界のオンライン学習者: 年間500万人（Udemy, Courseraなど）

**獲得コスト**: $20-50（オンライン広告）

**LTV**: $100-500（年間利用）

---

#### セグメント2: 技術サポート担当者

**ペルソナ**:
- 名前: 佐藤花子（32歳）
- 職業: SaaSスタートアップのカスタマーサクセス
- 課題: リモートで顧客に操作を説明するのが大変
- ニーズ: 画像付きの説明を自動生成したい

**市場規模**:
- 日本のテックサポート従事者: 約5万人
- 世界: 約200万人

**獲得コスト**: $100-200（B2B営業）

**LTV**: $1,000-5,000（企業契約）

---

#### セグメント3: オンライン教育プラットフォーム

**ペルソナ**:
- 組織: UdemyやCourseraのインストラクター
- 課題: コース動画作成に時間がかかる
- ニーズ: 操作手順の可視化を自動化

**市場規模**:
- Udemyインストラクター: 約7万人
- 全世界のオンライン講師: 約100万人

**獲得コスト**: $500-1,000（パートナーシップ）

**LTV**: $5,000-20,000（API利用・エンタープライズ）

---

#### セグメント4: 企業開発チーム

**ペルソナ**:
- 組織: スタートアップ〜大企業の開発部門
- 課題: 新人エンジニアのオンボーディングに時間がかかる
- ニーズ: 社内ツール・開発環境の使い方を効率的に教育

**市場規模**:
- 日本の開発者: 約100万人（うち新人: 年間10万人）
- 世界: 約2,700万人

**獲得コスト**: $1,000-5,000（エンタープライズ営業）

**LTV**: $10,000-100,000（年間契約）

---

### 収益モデル

#### モデル1: Freemium

```
無料プラン (Free):
- 月10回までの画像生成
- 基本的なスクリーンキャプチャ
- 手動注釈ツール
- コミュニティサポート

個人プラン ($9.99/月):
- 無制限の画像生成
- AI自動UI検出
- マルチステップガイド
- 優先サポート
- 動画生成（1080p）

プロプラン ($29.99/月):
- 個人プランの全機能
- オーバーレイ表示
- カスタムブランディング
- API アクセス
- チーム共有（5ユーザー）

ビジネスプラン ($99/月):
- プロプランの全機能
- 無制限チームメンバー
- SSO統合
- オンプレミスデプロイ
- 専任サポート
```

**収益予測（Year 1）**:

| プラン | 想定ユーザー数 | 月額単価 | 年間収益 |
|-------|--------------|---------|---------|
| 無料 | 100,000 | $0 | $0 |
| 個人 | 5,000 (5% conversion) | $10 | $600K |
| プロ | 500 | $30 | $180K |
| ビジネス | 100 | $100 | $120K |
| **合計** | **105,600** | - | **$900K** |

---

#### モデル2: Claude Code Pro Bundle

**統合オプション**:
```
Claude Code Pro + Visual Dev Assistant
価格: $19.99/月（単品より$10お得）

既存のClaude Codeユーザーへの
アップセル戦略
```

**利点**:
- 既存ユーザーベースの活用
- マーケティングコスト削減
- ブランド統一

**収益予測**:
- Claude Code Proユーザー: 10,000人（仮定）
- アップグレード率: 20%
- 追加収益: $10 × 2,000 × 12 = $240K/年

---

#### モデル3: Enterprise / API

**エンタープライズプラン**:
```
カスタム価格設定
- 専用インスタンス
- カスタムUI検出訓練
- オンボーディング支援
- SLA保証

想定価格: $999-9,999/月
```

**APIプラン**:
```
従量課金制
- $0.10/画像生成
- $1.00/動画生成（1分あたり）
- 月額基本料金: $299

対象: 教育プラットフォーム、SaaS企業
```

**収益予測**:
- エンタープライズ顧客: 20社
- 平均単価: $2,000/月
- 年間収益: $480K

- API利用: 100社
- 平均利用: $500/月
- 年間収益: $600K

**Enterprise合計**: $1,080K/年

---

### 総収益予測（Year 1-3）

| Year | ユーザー数 | ARR | 成長率 |
|------|----------|-----|-------|
| Year 1 | 105,600 | $900K | - |
| Year 2 | 250,000 | $2.5M | +180% |
| Year 3 | 500,000 | $5.5M | +120% |

---

## 市場分析

### 競合分析

#### 既存ソリューション

**1. Loom / CloudApp**
- **カテゴリ**: 画面録画ツール
- **機能**: 録画 + 簡易注釈
- **価格**: $12.50/月（Loom Business）
- **ユーザー**: 1,400万人（Loom）

**強み**:
- ✅ 既存の大規模ユーザーベース
- ✅ ブランド認知度
- ✅ 動画編集機能

**弱み**:
- ❌ AI支援なし（手動注釈）
- ❌ リアルタイムガイドなし
- ❌ 開発ツール特化なし

**差別化**:
- **AI自動検出** vs 手動
- **開発ツール最適化** vs 汎用
- **リアルタイムガイド** vs 録画後編集

---

**2. Skitch / Annotate**
- **カテゴリ**: スクリーンショット注釈ツール
- **機能**: スクショ + 手動注釈
- **価格**: 無料 or $4.99（買い切り）

**強み**:
- ✅ シンプル・直感的
- ✅ 低価格

**弱み**:
- ❌ 完全手動
- ❌ ステップバイステップなし
- ❌ AI機能なし

**差別化**:
- **自動化レベル**が圧倒的に高い

---

**3. WalkMe / Pendo**
- **カテゴリ**: Digital Adoption Platform
- **機能**: Webアプリ内ガイド
- **価格**: Enterprise（$10K+/年）

**強み**:
- ✅ エンタープライズ向け
- ✅ 高度な分析機能
- ✅ オンボーディング最適化

**弱み**:
- ❌ Web専用（デスクトップアプリ不可）
- ❌ 高価格
- ❌ 開発ツール非対応

**差別化**:
- **デスクトップアプリ対応**
- **開発ツール特化**
- **低価格帯**

---

**4. GitHub Copilot / Claude Code**
- **カテゴリ**: AI Coding Assistant
- **機能**: コード生成・説明
- **価格**: $10-20/月

**強み**:
- ✅ AI支援
- ✅ 開発者に特化
- ✅ IDE統合

**弱み**:
- ❌ GUI操作支援なし
- ❌ 視覚的ガイドなし

**差別化**:
- **補完的な関係**（競合ではなく統合）
- Copilot: コード ← → Visual Dev: GUI操作

---

### 競合マトリクス

| 特徴 | Visual Dev Assistant | Loom | WalkMe | Copilot |
|------|---------------------|------|--------|---------|
| AI自動UI検出 | ✅ | ❌ | ⚠️ Web限定 | ❌ |
| デスクトップアプリ対応 | ✅ | ⚠️ 録画のみ | ❌ | ❌ |
| リアルタイムガイド | ✅ | ❌ | ✅ | ❌ |
| 開発ツール特化 | ✅ | ❌ | ❌ | ✅ |
| 価格 | $10-30 | $12.50 | $10K+ | $10-20 |
| ステップバイステップ | ✅ | ❌ | ✅ | ❌ |

---

### 市場規模

**TAM (Total Addressable Market)**:
```
全世界の開発者: 2,700万人
教育関係者: 100万人
技術サポート: 200万人
----------------------------
合計: 約3,000万人

平均単価: $15/月
TAM = 3,000万人 × $15 × 12 = $5.4B（約54億ドル）
```

**SAM (Serviceable Addressable Market)**:
```
英語圏 + 日本: 約800万人
SAM = 800万人 × $15 × 12 = $1.4B
```

**SOM (Serviceable Obtainable Market, Year 3)**:
```
市場シェア: 1%
SOM = $1.4B × 1% = $14M
```

---

## 技術的課題と解決策

### 課題1: macOSのセキュリティ制限

#### 問題

**Screen Recording権限**:
```
macOS 10.15+では、画面キャプチャに
明示的なユーザー許可が必要
```

**Accessibility権限**:
```
UI要素の情報取得にAccessibility APIが必要
→ 追加の権限リクエスト
```

**公証（Notarization）**:
```
macOS 10.15+で配布するアプリは
Appleの公証が必要
→ 開発者アカウント（$99/年）が必要
```

#### 解決策

**権限リクエストの最適化**:
```swift
// 初回起動時に分かりやすい説明を表示
func requestScreenCapturePermission() {
    let alert = NSAlert()
    alert.messageText = "Screen Capture Permission"
    alert.informativeText = """
    Visual Dev Assistant needs permission to
    capture your screen to create visual guides.

    This is only used when you explicitly request it.
    No data is sent to external servers.
    """
    alert.addButton(withTitle: "Open Settings")
    alert.addButton(withTitle: "Cancel")

    if alert.runModal() == .alertFirstButtonReturn {
        // システム設定を開く
        NSWorkspace.shared.open(
            URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_ScreenCapture")!
        )
    }
}
```

**段階的な権限取得**:
```
1. 最初は権限なしでデモを表示
2. ユーザーが価値を理解してから権限リクエスト
3. 明確な説明 + プライバシーポリシー
```

**公証の自動化**:
```bash
# CI/CDパイプラインで自動公証
xcodebuild archive ...
xcrun notarytool submit app.zip \
  --apple-id "your@email.com" \
  --password "@keychain:AC_PASSWORD" \
  --team-id "TEAM_ID" \
  --wait

xcrun stapler staple VisualDevAssistant.app
```

---

### 課題2: UI要素検出の精度

#### 問題

**アプリ間の違い**:
- Xcodeのボタン vs VS Codeのボタン
- 異なる色・サイズ・配置

**ダークモード/ライトモード**:
- 同じボタンでも色が反転
- 色ベースの検出が困難

**解像度・DPI差異**:
- Retinaディスプレイ vs 通常
- 4K vs 1080p

**動的UI**:
- メニューが開閉
- ポップオーバーが表示/非表示
- アニメーション中

#### 解決策

**マルチモーダル検出**:
```python
def detect_with_confidence(image):
    results = []

    # 方法1: OCR
    ocr_result = detect_with_ocr(image)
    results.append(('ocr', ocr_result, 0.8))

    # 方法2: エッジ検出
    edge_result = detect_with_edges(image)
    results.append(('edge', edge_result, 0.6))

    # 方法3: 色検出
    color_result = detect_with_color(image)
    results.append(('color', color_result, 0.5))

    # 方法4: ML モデル（オプション）
    if ml_model_available:
        ml_result = detect_with_ml(image)
        results.append(('ml', ml_result, 0.9))

    # 投票・統合
    final_result = vote_and_merge(results)
    return final_result
```

**アプリケーション固有プロファイル**:
```json
{
  "Xcode": {
    "toolbar_height": 40,
    "button_style": "rounded",
    "color_scheme": {
      "light": {"play_button": "#007AFF"},
      "dark": {"play_button": "#0A84FF"}
    },
    "known_elements": [
      {"name": "Build", "icon": "play", "position": "top-center"},
      {"name": "Stop", "icon": "stop", "position": "top-center"}
    ]
  }
}
```

**適応的学習**:
```python
# ユーザーの確認から学習
if user_confirmed:
    # 正しく検出できた例を保存
    save_positive_example(image, element, app_name)

if user_corrected:
    # 間違った例から学習
    save_negative_example(image, element, app_name)
    # 次回は精度が向上
```

---

### 課題3: パフォーマンス

#### 問題

**画面キャプチャのオーバーヘッド**:
- 4K画面: 3840×2160 = 830万ピクセル
- 60fpsでキャプチャ: 830万 × 60 × 4バイト = 約2GB/秒

**画像処理の時間**:
- OCR: 1-2秒
- エッジ検出: 0.5-1秒
- ML推論: 0.1-0.5秒

**リアルタイム性の要求**:
- ユーザーは即座に結果を期待
- 2秒以上待たせるとUX悪化

#### 解決策

**高速キャプチャAPI**:
```swift
// ScreenCaptureKit (macOS 12.3+)
// 従来のCGWindowListCreateImageより5-10倍高速
let config = SCStreamConfiguration()
config.width = targetWidth
config.height = targetHeight
config.pixelFormat = kCVPixelFormatType_32BGRA

let stream = SCStream(
    filter: filter,
    configuration: config,
    delegate: self
)
```

**非同期処理**:
```python
async def process_visual_guide(instruction, app_name):
    # 並列実行
    screenshot, elements = await asyncio.gather(
        capture_async(app_name),
        load_previous_elements(app_name)  # キャッシュ
    )

    # OCRとエッジ検出を並列化
    ocr_task = asyncio.create_task(run_ocr(screenshot))
    edge_task = asyncio.create_task(detect_edges(screenshot))

    ocr_result, edge_result = await asyncio.gather(
        ocr_task,
        edge_task
    )

    # 統合して返却
    return merge_results(ocr_result, edge_result)
```

**インクリメンタル更新**:
```python
class IncrementalDetector:
    def __init__(self):
        self.previous_screenshot = None
        self.previous_elements = []

    def detect(self, current_screenshot):
        # 前回との差分をチェック
        diff = calculate_difference(
            self.previous_screenshot,
            current_screenshot
        )

        if diff < THRESHOLD:
            # ほとんど変化がない → 前回の結果を再利用
            return self.previous_elements

        # 変化があった部分のみ再検出
        changed_regions = detect_changed_regions(diff)
        new_elements = detect_in_regions(
            current_screenshot,
            changed_regions
        )

        # 結果を更新
        self.previous_screenshot = current_screenshot
        self.previous_elements = merge_elements(
            self.previous_elements,
            new_elements
        )

        return self.previous_elements
```

**GPUアクセラレーション**:
```python
import cv2

# OpenCV with CUDA
cv2.setUseOptimized(True)
if cv2.cuda.getCudaEnabledDeviceCount() > 0:
    # GPU版のアルゴリズムを使用
    gpu_mat = cv2.cuda_GpuMat()
    gpu_mat.upload(image)
    result = cv2.cuda.Canny(gpu_mat, 50, 150)
    result = result.download()
```

**プログレッシブレンダリング**:
```
1. 即座に画面キャプチャを表示 (0.1秒)
2. シンプルな矢印を追加 (0.3秒)
3. より正確な検出結果で更新 (1-2秒)
4. 最終的な高品質な注釈 (3秒)

→ ユーザーは待たされている感じがしない
```

---

### 課題4: Claude Code統合

#### 問題

**APIインターフェース設計**:
- どのようなパラメータを受け取るか
- どのような形式で結果を返すか

**画像の送受信**:
- 画像サイズが大きい（1-5MB）
- base64エンコーディングでさらに増加
- ネットワーク帯域の制約

**タイミング制御**:
- いつ視覚ガイドを表示するか
- 自動 vs 明示的なリクエスト

#### 解決策

**シンプルなTool API**:
```python
{
  "name": "show_visual_guide",
  "description": "Show visual guide for GUI operation",
  "parameters": {
    "instruction": {
      "type": "string",
      "required": true
    },
    "app_name": {
      "type": "string",
      "required": false
    }
  }
}

# 使用例
show_visual_guide(
    instruction="Click the Build button",
    app_name="Xcode"
)
```

**画像最適化**:
```python
def optimize_image_for_transfer(image):
    # 1. リサイズ（最大1920x1080）
    max_size = (1920, 1080)
    image.thumbnail(max_size, Image.LANCZOS)

    # 2. JPEG圧縮（品質80%）
    buffer = BytesIO()
    image.save(buffer, format='JPEG', quality=80, optimize=True)

    # 3. WebPフォーマット（さらに30%削減）
    # if webp_supported:
    #     image.save(buffer, format='WEBP', quality=80)

    # 4. base64エンコード
    img_str = base64.b64encode(buffer.getvalue()).decode()

    return img_str

# Before: 5MB PNG
# After: 500KB JPEG (base64) = 10倍削減
```

**スマートな表示タイミング**:
```python
class ClaudeIntegration:
    def should_show_visual_guide(self, context):
        """視覚ガイドを表示すべきか判定"""

        # ユーザーが明示的にリクエスト
        if context.explicit_request:
            return True

        # 位置を尋ねる質問
        if re.search(r'where|どこ|場所', context.user_message, re.I):
            return True

        # ユーザーが困っている兆候
        if context.retry_count > 2:
            return True

        # GUIに関する指示
        if re.search(r'click|select|choose|クリック', context.assistant_message, re.I):
            return True

        return False
```

**結果のキャッシュ**:
```python
cache = {}

def get_visual_guide_cached(instruction, app_name):
    # キャッシュキーを生成
    key = f"{app_name}:{instruction}:{screen_hash}"

    if key in cache:
        # キャッシュヒット（即座に返却）
        return cache[key]

    # キャッシュミス（生成して保存）
    result = generate_visual_guide(instruction, app_name)
    cache[key] = result
    return result
```

---

## 次のステップ

### 即座に実行可能なアクション

1. **MVP開発開始**
   ```bash
   # プロジェクトセットアップ
   mkdir visual-dev-assistant
   cd visual-dev-assistant
   python3 -m venv venv
   source venv/bin/activate
   pip install pillow pyobjc pytesseract opencv-python
   ```

2. **最小限のプロトタイプ**
   - 画面キャプチャ
   - 固定位置への矢印描画
   - PNG保存

   **期間**: 2-3日

3. **初期ユーザーテスト**
   - 5-10人のプログラミング初心者
   - フィードバック収集
   - コンセプト検証

---

### 意思決定が必要な項目

#### Q1: 技術スタックの選択

**オプション**:
- A: Python（迅速なMVP）
- B: Swift（最終製品品質）
- C: Electron（クロスプラットフォーム）

**推奨**: **A → B** のハイブリッド

---

#### Q2: 最初のターゲット市場

**オプション**:
- A: 個人開発者（B2C）
- B: 企業チーム（B2B）
- C: 教育機関（B2B2C）

**推奨**: **A（個人）**で開始 → B/Cに拡大

---

#### Q3: Claude Code統合のタイミング

**オプション**:
- A: MVP段階から統合
- B: Phase 2で統合
- C: 独立プロダクトとして開発

**推奨**: **B（Phase 2）** - まず独立して動作を確認

---

## 結論

### プロダクトの価値提案

**Visual Dev Assistant**は、AI開発アシスタントとユーザーの間の「視覚的なギャップ」を埋める、これまでにないツールです。

**核心的な価値**:
1. **学習効率の向上**: テキスト説明の10倍わかりやすい
2. **生産性の向上**: サポート時間を50%削減
3. **アクセシビリティ**: 初心者でも複雑なツールを使える

### 実現可能性

**技術的実現可能性**: ★★★★★ (5/5)
- 必要な技術は全て利用可能
- MVP開発期間: 2-3週間

**市場の準備**: ★★★★☆ (4/5)
- AIツールの認知度が高まっている
- リモートワークで需要増加

**競合優位性**: ★★★★☆ (4/5)
- 明確な差別化ポイント
- 既存製品にない機能

### 推奨アクション

**短期（1-3ヶ月）**:
1. Python MVPを開発（2-3週間）
2. 初期ユーザーテスト（10-20人）
3. フィードバック反映

**中期（3-6ヶ月）**:
4. Swift版の本格開発
5. Claude Code統合
6. ベータリリース

**長期（6-12ヶ月）**:
7. 正式リリース
8. 市場拡大（教育・企業）
9. クロスプラットフォーム対応

---

**このプロダクトを作りますか？**

選択肢:
1. Visual Dev Assistantの開発を開始する
2. Apple Watchアプリを先に完成させる
3. 両方を並行して進める

次のセッションでの方向性を教えてください。

---

**ドキュメント作成日**: 2025年11月11日
**次回レビュー**: プロトタイプ完成時
**連絡先**: GitHub - https://github.com/itiyabosi/motion-detector
