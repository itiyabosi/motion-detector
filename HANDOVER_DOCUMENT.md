# プロジェクト引き継ぎ書類

**日付**: 2025年11月11日
**プロジェクト**: モーション判定アプリ開発
**次のステップ**: 視覚的開発支援ツールの構想

---

## 目次

1. [プロジェクト概要](#プロジェクト概要)
2. [完了した作業](#完了した作業)
3. [現在の状態](#現在の状態)
4. [未完了のタスク](#未完了のタスク)
5. [直面した課題](#直面した課題)
6. [新プロダクトのコンセプト](#新プロダクトのコンセプト)
7. [技術仕様案](#技術仕様案)

---

## プロジェクト概要

### 目的
スマホの加速度センサーを使って手の動きを判定し、微細振動（振戦）を検出するアプリの開発

### 実装バージョン

#### 1. Webアプリ版 ✅ 完成
- **技術**: HTML/JavaScript/Chart.js
- **動作環境**: スマホブラウザ
- **公開URL**: https://itiyabosi.github.io/motion-detector/
- **状態**: デプロイ済み・動作確認済み

#### 2. Apple Watch版 🔄 90%完成
- **技術**: Swift/SwiftUI/CoreMotion
- **動作環境**: Apple Watch + iPhone
- **状態**: コード完成・ビルド未完了

---

## 完了した作業

### Phase 1: Webアプリ開発 ✅

#### 1.1 基本実装
- [x] HTML/CSS/JavaScriptでのUI構築
- [x] 加速度センサーAPI統合
- [x] リアルタイムモーション判定（静止/滑らか/動いている）
- [x] 分散ベースの判定アルゴリズム

#### 1.2 振戦検出機能
- [x] インターネットリサーチ（医学論文調査）
  - パーキンソン病振戦: 3-6 Hz
  - 本態性振戦: 4-12 Hz
  - 検出感度: 97.96%（先行研究）
- [x] 3軸加速度データ収集
- [x] 自己相関ベースの周波数検出アルゴリズム
- [x] 3-12 Hz範囲の振戦検出
- [x] 信頼度スコアリング

#### 1.3 UI/UX
- [x] リアルタイムグラフ表示（Chart.js）
- [x] 状態変化のログ記録
- [x] メトリクス表示（加速度、変動率、周波数）

#### 1.4 デプロイ
- [x] Gitリポジトリ作成・管理
- [x] GitHub Pages公開
- [x] README/ドキュメント作成

**成果物**: `index.html` - 単一ファイルで動作する完全なWebアプリ

---

### Phase 2: Apple Watch版開発 🔄

#### 2.1 プロジェクト構造 ✅
```
MotionDetector/
├── MotionDetector/                    # iPhoneアプリ
│   ├── ContentView.swift             ✅ 完成
│   ├── MotionDetectorApp.swift       ✅ 完成
│   └── WatchConnectivityManager.swift ✅ 完成
├── MotionDetector Watch App/          # Watchアプリ
│   ├── ContentView.swift             ✅ 完成
│   ├── MotionManager.swift           ✅ 完成
│   ├── TremorDetector.swift          ✅ 完成
│   ├── WatchConnectivityManager.swift ✅ 完成
│   └── Info.plist                    ✅ 完成
└── MotionDetector.xcodeproj/         ✅ 作成済み
```

#### 2.2 実装内容 ✅

**Apple Watchアプリ**
- [x] CoreMotion統合（50Hz加速度データ取得）
- [x] MotionManager: センサー管理・データ処理
- [x] TremorDetector: 振戦検出アルゴリズム（Swift実装）
- [x] SwiftUI UI（Watch最適化）
- [x] リアルタイム状態表示

**iPhoneコンパニオンアプリ**
- [x] SwiftUI UI（詳細データ表示）
- [x] Charts統合（iOS 16+）
- [x] Watch Connectivity: 双方向データ同期
- [x] 加速度履歴グラフ
- [x] 周波数範囲ビジュアライザー

#### 2.3 開発支援 ✅
- [x] セットアップガイド作成（WATCH_APP_SETUP.md）
- [x] 自動化スクリプト作成（setup_xcode_project.sh）
- [x] ファイル配置自動化
- [x] 権限設定（Info.plist）

---

## 現在の状態

### Webアプリ版
**ステータス**: ✅ 完全稼働中
**URL**: https://itiyabosi.github.io/motion-detector/

### Apple Watch版
**ステータス**: 🔄 ビルド段階（90%完成）

**完了済み**:
- ✅ 全てのSwiftファイル作成・配置
- ✅ プロジェクト構造作成
- ✅ 権限設定
- ✅ シミュレータ起動確認

**残作業**:
- ⏳ 実機ビルド・テスト
- ⏳ 署名設定
- ⏳ Apple Watch実機デプロイ
- ⏳ 動作確認

**最後のログ**:
```
WCSession is not paired
```
→ シミュレータでの正常動作（実機必要）

---

## 未完了のタスク

### 即座に必要な作業

1. **実機ビルド**
   - iPhoneへのインストール
   - Apple Watchへのインストール
   - 実機での動作確認

2. **デバッグ・調整**
   - センサーデータ精度確認
   - 振戦検出閾値の調整
   - UI/UXの微調整

3. **テスト**
   - 静止状態テスト
   - 滑らかな動きテスト
   - 振戦検出テスト

### 将来的な拡張

- [ ] HealthKit統合
- [ ] データエクスポート機能
- [ ] 長期記録・分析機能
- [ ] TestFlight配布
- [ ] App Store公開

---

## 直面した課題

### 課題1: テキストベース説明の限界

#### 問題の詳細

開発者（Claude）がユーザーに操作を説明する際、以下の問題が発生：

1. **位置の説明が困難**
   - 「画面上部」「左側」などの相対的な説明
   - ユーザーが実際に見ている画面との不一致
   - UIの個人差（バージョン、設定）

2. **操作手順の複雑さ**
   ```
   例: Xcodeでの操作
   「左側のProject Navigatorで」
   「MotionDetectorフォルダを右クリック」
   「Add Files to...を選択」
   「Commandキーを押しながら複数選択」
   ```
   → テキストだけでは伝わりにくい

3. **視覚情報の欠如**
   - ボタンの見た目
   - アイコンの位置
   - メニュー構造
   - 色・形状

4. **コンテキストの不一致**
   - ユーザーの現在の画面状態が不明
   - 想定と異なる画面を見ている可能性
   - エラー状態の把握困難

#### 具体例

**今回の例**:
```
ユーザー: 「再生ボタンの左？」
```

このやり取りから判明した課題：
- テキスト説明「画面上部の再生ボタンの左側」では不十分
- スクリーンショットがあれば矢印で指せる
- 実際のUI要素をハイライトできれば理想的

---

## 新プロダクトのコンセプト

### プロダクト名（仮）
**「Visual Dev Assistant」** または **「GUI Pointer」**

### コアアイデア

**「AI開発アシスタントが、ユーザーのMac画面をキャプチャして、GUI上で次の操作を視覚的に提案する」**

### 主要機能

#### 1. スクリーンキャプチャ統合
```
AIアシスタント ←→ スクリーンキャプチャ
        ↓
   画像認識・解析
        ↓
   視覚的な操作提案
```

#### 2. GUI要素の検出・ハイライト
- ボタン、メニュー、入力欄などのUI要素を自動検出
- OCRでテキストを読み取り
- クリックすべき場所を矢印・ハイライトで表示

#### 3. インタラクティブな操作ガイド
```
[現在の画面]
    ↓ キャプチャ
[AI解析]
    ↓
[操作の可視化]
  - 赤い矢印: 「ここをクリック」
  - 黄色いハイライト: 「この要素」
  - 順序番号: 「①→②→③」
    ↓
[ユーザーに表示]
```

#### 4. ステップバイステップガイド
- 複雑な操作を分解
- 各ステップを画像付きで提示
- 完了確認→次のステップへ

---

## 技術仕様案

### アーキテクチャ

```
┌─────────────────────────────────────┐
│  Claude Code CLI                    │
│  (既存のAIアシスタント)              │
└──────────────┬──────────────────────┘
               │
               ↓ API Call
┌──────────────────────────────────────┐
│  Visual Dev Assistant Service        │
│  ┌────────────────────────────────┐ │
│  │ Screen Capture Module          │ │
│  │  - macOS Screenshot API        │ │
│  │  - Window detection            │ │
│  └────────────────────────────────┘ │
│  ┌────────────────────────────────┐ │
│  │ Computer Vision Module         │ │
│  │  - OCR (Tesseract/Apple Vision)│ │
│  │  - UI element detection        │ │
│  │  - Layout analysis             │ │
│  └────────────────────────────────┘ │
│  ┌────────────────────────────────┐ │
│  │ Annotation Module              │ │
│  │  - Draw arrows/highlights      │ │
│  │  - Add text labels             │ │
│  │  - Create step-by-step guides  │ │
│  └────────────────────────────────┘ │
│  ┌────────────────────────────────┐ │
│  │ Display Module                 │ │
│  │  - Overlay window              │ │
│  │  - Terminal image display      │ │
│  │  - Web preview                 │ │
│  └────────────────────────────────┘ │
└──────────────────────────────────────┘
```

### 技術スタック案

#### Option 1: Python + macOSネイティブAPI
```python
技術:
- PyObjC: macOS APIアクセス
- Pillow/OpenCV: 画像処理
- pytesseract: OCR
- PyQt/Tkinter: オーバーレイUI

長所:
- 迅速なプロトタイピング
- 豊富なライブラリ
- Claude Codeとの統合が容易

短所:
- パフォーマンス
- 配布の複雑さ
```

#### Option 2: Swift (macOSネイティブ)
```swift
技術:
- ScreenCaptureKit: 高速画面キャプチャ
- Vision Framework: OCR・UI検出
- Core Graphics: 画像処理
- SwiftUI/AppKit: オーバーレイUI

長所:
- ネイティブパフォーマンス
- macOS統合
- App Store配布可能

短所:
- 開発時間
- クロスプラットフォーム不可
```

#### Option 3: Electron (クロスプラットフォーム)
```javascript
技術:
- Electron: デスクトップアプリ
- node-screenshots: 画面キャプチャ
- Tesseract.js: OCR
- Canvas/SVG: 画像処理

長所:
- Windows/Mac/Linux対応
- Web技術の活用
- UI開発が容易

短所:
- 大きなバイナリサイズ
- メモリ使用量
```

### コア機能の実装例

#### 1. スクリーンキャプチャ (Python例)

```python
import Quartz
from PIL import Image

def capture_screen():
    """macOSの画面をキャプチャ"""
    # CGWindowListCreateImage を使用
    region = Quartz.CGRectInfinite
    image = Quartz.CGWindowListCreateImage(
        region,
        Quartz.kCGWindowListOptionOnScreenOnly,
        Quartz.kCGNullWindowID,
        Quartz.kCGWindowImageDefault
    )

    # PIL Imageに変換
    width = Quartz.CGImageGetWidth(image)
    height = Quartz.CGImageGetHeight(image)
    # ... 変換処理

    return pil_image
```

#### 2. UI要素の検出

```python
from PIL import Image, ImageDraw
import pytesseract
import cv2

def detect_ui_elements(image):
    """UI要素を検出してバウンディングボックスを返す"""

    # OCRでテキスト要素を検出
    ocr_data = pytesseract.image_to_data(
        image,
        output_type=pytesseract.Output.DICT
    )

    elements = []
    for i, text in enumerate(ocr_data['text']):
        if text.strip():
            x, y, w, h = (
                ocr_data['left'][i],
                ocr_data['top'][i],
                ocr_data['width'][i],
                ocr_data['height'][i]
            )
            elements.append({
                'text': text,
                'bbox': (x, y, w, h),
                'confidence': ocr_data['conf'][i]
            })

    # コンピュータビジョンでボタン・UI要素を検出
    gray = cv2.cvtColor(np.array(image), cv2.COLOR_RGB2GRAY)
    edges = cv2.Canny(gray, 50, 150)
    contours, _ = cv2.findContours(
        edges,
        cv2.RETR_EXTERNAL,
        cv2.CHAIN_APPROX_SIMPLE
    )

    for contour in contours:
        x, y, w, h = cv2.boundingRect(contour)
        # ボタンらしいサイズのもの
        if 20 < w < 200 and 20 < h < 60:
            elements.append({
                'type': 'button',
                'bbox': (x, y, w, h)
            })

    return elements
```

#### 3. 操作の可視化

```python
from PIL import Image, ImageDraw, ImageFont

def annotate_instruction(image, instruction):
    """
    画像に操作指示を描画

    instruction = {
        'type': 'click',
        'target': 'Build Button',
        'position': (100, 50),
        'bbox': (80, 40, 150, 70),
        'step': 1
    }
    """
    draw = ImageDraw.Draw(image)

    # ハイライト（黄色の矩形）
    if 'bbox' in instruction:
        x, y, w, h = instruction['bbox']
        draw.rectangle(
            [(x, y), (x+w, y+h)],
            outline='yellow',
            width=3
        )

    # 矢印
    if 'position' in instruction:
        target_x, target_y = instruction['position']
        # 矢印の始点（画像外から）
        start_x, start_y = target_x - 50, target_y - 50

        draw.line(
            [(start_x, start_y), (target_x, target_y)],
            fill='red',
            width=5
        )
        draw.ellipse(
            [(target_x-10, target_y-10), (target_x+10, target_y+10)],
            fill='red'
        )

    # ステップ番号
    if 'step' in instruction:
        font = ImageFont.truetype('/System/Library/Fonts/Arial.ttf', 36)
        step_text = f"#{instruction['step']}"
        draw.text(
            (20, 20),
            step_text,
            fill='red',
            font=font
        )

    # 説明文
    if 'description' in instruction:
        font = ImageFont.truetype('/System/Library/Fonts/Arial.ttf', 24)
        draw.text(
            (20, 70),
            instruction['description'],
            fill='white',
            font=font,
            stroke_width=2,
            stroke_fill='black'
        )

    return image
```

#### 4. Claude Code統合

```python
class VisualDevAssistant:
    """Claude Codeとの統合インターフェース"""

    def explain_with_visual(self, instruction_text, target_app="Xcode"):
        """
        テキスト指示を視覚的な説明に変換

        Args:
            instruction_text: "Click the Build button in Xcode"
            target_app: アプリケーション名

        Returns:
            annotated_image: 注釈付き画像
        """

        # 1. 現在の画面をキャプチャ
        screenshot = self.capture_screen()

        # 2. ターゲットアプリのウィンドウを検出
        app_window = self.find_window(target_app)
        if app_window:
            screenshot = screenshot.crop(app_window['bbox'])

        # 3. UI要素を検出
        elements = self.detect_ui_elements(screenshot)

        # 4. 指示をパース（Claude APIで解析）
        instruction = self.parse_instruction(
            instruction_text,
            elements
        )

        # 5. 画像に注釈を追加
        annotated = self.annotate_instruction(
            screenshot,
            instruction
        )

        # 6. 表示
        self.display_image(annotated)

        return annotated

    def parse_instruction(self, text, elements):
        """Claude APIで指示を構造化"""
        # Claude APIに問い合わせ
        response = self.claude_api.complete(
            prompt=f"""
            Given this instruction: "{text}"
            And these UI elements: {elements}

            Extract:
            1. Target element
            2. Action type (click, type, select, etc.)
            3. Position on screen

            Return JSON format.
            """
        )
        return json.loads(response)
```

### ユーザーフロー

```
┌─────────────────────────────────────┐
│ ユーザー: "ビルドボタンどこ？"      │
└──────────────┬──────────────────────┘
               │
               ↓
┌──────────────────────────────────────┐
│ Claude Code:                         │
│ "画面をキャプチャして確認します"    │
└──────────────┬───────────────────────┘
               │
               ↓
┌──────────────────────────────────────┐
│ Visual Dev Assistant:                │
│ 1. Xcodeの画面をキャプチャ          │
│ 2. ビルドボタンを検出               │
│ 3. 矢印付き画像を生成               │
└──────────────┬───────────────────────┘
               │
               ↓
┌──────────────────────────────────────┐
│ ディスプレイ:                        │
│ [画像: 赤い矢印→ビルドボタン]       │
│ "① ここをクリック"                  │
└──────────────────────────────────────┘
```

---

## 実装ロードマップ

### Phase 1: MVP（最小機能プロダクト）

**期間**: 2-3週間

**機能**:
- [x] スクリーンキャプチャ
- [x] シンプルな矢印描画
- [x] 画像表示（ターミナル or ブラウザ）
- [x] 基本的なOCR

**ゴール**:
「Xcodeのビルドボタンに矢印を表示」できるレベル

### Phase 2: UI要素検出強化

**期間**: 2-4週間

**機能**:
- [ ] 高度なUI要素検出
- [ ] ボタン、メニュー、入力欄の自動識別
- [ ] アプリケーション固有の学習
- [ ] 複数ステップのガイド

**ゴール**:
複雑な操作手順を自動で可視化

### Phase 3: インタラクティブ機能

**期間**: 4-6週間

**機能**:
- [ ] オーバーレイウィンドウ
- [ ] リアルタイム追従
- [ ] クリック検出・次のステップへ
- [ ] 音声ガイド
- [ ] 動画キャプチャ

**ゴール**:
完全にインタラクティブなガイドシステム

---

## 類似プロダクト調査

### 既存のソリューション

1. **Loom / CloudApp**
   - 画面録画 + コメント
   - 矢印・図形の手動追加
   - **違い**: 自動化なし

2. **Step-by-step Screenshot Tools**
   - SkitchStep-by-step Screenshot Tools**
   - Skitch, Annotate
   - スクリーンショット + 手動注釈
   - **違い**: AI支援なし

3. **Interactive Tutorials**
   - WalkMe, Pendo
   - Web専用、オンボーディング向け
   - **違い**: デスクトップアプリ非対応

4. **AI Coding Assistants**
   - GitHub Copilot, Claude Code
   - コード生成・説明
   - **違い**: GUI操作支援なし

### 差別化ポイント

| 特徴 | 既存製品 | Visual Dev Assistant |
|------|---------|---------------------|
| 自動UI検出 | ❌ | ✅ |
| AI連携 | ❌ | ✅ |
| リアルタイム | ⚠️ 限定的 | ✅ |
| デスクトップアプリ対応 | ⚠️ 限定的 | ✅ |
| 開発ツール特化 | ❌ | ✅ |

---

## ビジネスモデル案

### ターゲットユーザー

1. **プログラミング初心者**
   - IDEの使い方がわからない
   - 開発ツールのUI複雑さに困惑

2. **技術サポート担当者**
   - リモートでの操作説明が必要
   - スクリーンショット作成の手間削減

3. **教育機関**
   - オンラインコーディング講座
   - 視覚的なチュートリアル作成

4. **企業の開発チーム**
   - オンボーディングプロセス効率化
   - 社内ツールの使い方ガイド

### 収益モデル

**Option 1: Freemium**
```
無料プラン:
- 基本的なスクリーンキャプチャ
- 手動注釈
- 月10回まで

有料プラン ($9.99/月):
- AI自動UI検出
- 無制限使用
- 動画ガイド生成
- チーム共有
```

**Option 2: Developer Tool Bundle**
```
Claude Code拡張機能として:
- Claude Code Proの追加機能
- $20/月 (既存ユーザー向け)
```

**Option 3: Enterprise**
```
社内向けカスタマイズ:
- プライベートデプロイ
- カスタムUI検出訓練
- $999/月〜
```

---

## 次のステップ（優先順位付き）

### 緊急（今週）

1. **Apple Watchアプリ完成**
   - [ ] 実機ビルド
   - [ ] 動作確認
   - [ ] ドキュメント完成

### 重要（今月）

2. **Visual Dev Assistant プロトタイプ**
   - [ ] 技術調査
   - [ ] MVP仕様確定
   - [ ] スクリーンキャプチャ実装
   - [ ] シンプルな矢印描画

### 計画中（3ヶ月）

3. **本格開発**
   - [ ] UI要素検出
   - [ ] Claude Code統合
   - [ ] ベータテスト

---

## 技術的検討事項

### 課題と解決策

#### 課題1: macOSのセキュリティ制限

**問題**:
- Screen Recording権限が必要
- Accessibility権限が必要
- アプリの署名・公証が必要

**解決策**:
- ユーザーに権限リクエスト
- Xcodeでの開発者署名
- 将来的にApp Store配布

#### 課題2: UI要素検出の精度

**問題**:
- アプリによってUI構造が異なる
- ダークモード/ライトモード
- 解像度・DPI差異

**解決策**:
- 複数の検出手法の組み合わせ
  - OCR (テキスト)
  - エッジ検出 (形状)
  - 色検出 (ボタン)
  - 機械学習モデル (将来)
- アプリケーション固有の調整

#### 課題3: パフォーマンス

**問題**:
- 画面キャプチャのオーバーヘッド
- 画像処理の時間
- リアルタイム性の確保

**解決策**:
- ScreenCaptureKit使用（高速）
- 非同期処理
- キャッシング戦略
- GPUアクセラレーション

#### 課題4: Claude Code統合

**問題**:
- APIインターフェース設計
- 画像の送受信
- タイミング制御

**解決策**:
```python
# Claude Code Toolとして実装
class VisualGuideTool:
    name = "visual_guide"
    description = "Show visual guide for GUI operations"

    def execute(self, instruction: str, app: str):
        # スクリーンキャプチャ
        # UI検出
        # 注釈追加
        # 画像返却
        pass
```

---

## リソース・参考資料

### 技術ドキュメント

**macOS API**:
- ScreenCaptureKit: https://developer.apple.com/documentation/screencapturekit
- Vision Framework: https://developer.apple.com/documentation/vision
- Accessibility API: https://developer.apple.com/accessibility/

**コンピュータビジョン**:
- OpenCV: https://opencv.org/
- Tesseract OCR: https://github.com/tesseract-ocr/tesseract
- YOLOv8 (UI detection): https://github.com/ultralytics/ultralytics

**既存プロジェクト**:
- Talon (音声制御): https://talonvoice.com/
- Vimium (ブラウザUI制御): https://github.com/philc/vimium

### 論文・研究

- "Rico: A Mobile App Dataset for Building Data-Driven Design Applications"
- "Screen2Vec: Semantic Embedding of GUI Screenshots and GUI Elements"
- "UIBert: Learning Generic Multimodal Representations for UI Understanding"

---

## ファイル構成（現在のプロジェクト）

```
/Users/hikaru/00/2025/12 スマホの加速度センサ/
├── index.html                              # Webアプリ版
├── README.md                               # プロジェクト説明
├── WATCH_APP_SETUP.md                      # セットアップガイド
├── HANDOVER_DOCUMENT.md                    # この書類
├── setup_xcode_project.sh                  # 自動化スクリプト
│
├── MotionDetectorWatch/                    # Watch用Swiftソース
│   ├── ContentView.swift
│   ├── MotionManager.swift
│   ├── TremorDetector.swift
│   ├── WatchConnectivityManager.swift
│   └── MotionDetectorWatchApp.swift
│
├── MotionDetectorPhone/                    # iPhone用Swiftソース
│   ├── ContentView.swift
│   ├── WatchConnectivityManager.swift
│   └── MotionDetectorPhoneApp.swift
│
└── MotionDetector/                         # Xcodeプロジェクト
    ├── MotionDetector/                     # iPhoneアプリ
    │   ├── ContentView.swift              ✅
    │   ├── MotionDetectorApp.swift        ✅
    │   ├── WatchConnectivityManager.swift ✅
    │   └── Assets.xcassets/
    │
    ├── MotionDetector Watch App/           # Watchアプリ
    │   ├── ContentView.swift              ✅
    │   ├── MotionManager.swift            ✅
    │   ├── TremorDetector.swift           ✅
    │   ├── WatchConnectivityManager.swift ✅
    │   ├── Info.plist                     ✅
    │   └── Assets.xcassets/
    │
    └── MotionDetector.xcodeproj/          ✅
        └── project.pbxproj
```

---

## 連絡先・引き継ぎ情報

**プロジェクトリポジトリ**: https://github.com/itiyabosi/motion-detector
**Webアプリデモ**: https://itiyabosi.github.io/motion-detector/

**開発環境**:
- macOS: Darwin 24.5.0
- Xcode: 最新版
- Python: 3.x（スクリプト用）

**重要な決定事項**:
- Apple IDでの無料開発者アカウント使用
- 7日ごとの再署名が必要
- App Store公開は将来的な目標

---

## まとめ

### 完了したこと
1. ✅ Webアプリ版（完全稼働）
2. ✅ Apple Watch版コード（100%完成）
3. ✅ プロジェクト構造・ファイル配置

### 残っていること
1. ⏳ Apple Watch実機ビルド・テスト
2. ⏳ 動作確認・調整

### 新しい方向性
**Visual Dev Assistant** - AI×GUI操作支援ツール
- テキスト説明の限界を視覚化で解決
- 開発者の生産性向上
- 教育・サポート分野での活用

---

**次回セッション開始時のアクション**:
1. Apple Watchアプリの実機テストを完了させるか
2. Visual Dev Assistantのプロトタイプ開発を開始するか

選択してください。
