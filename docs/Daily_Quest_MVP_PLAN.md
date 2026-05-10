# Daily Quest MVP 実装計画書

旧 TriTask v1.0.0 を、レトロRPG風タスク管理アプリ **Daily Quest** としてリメイクするためのMVP実装計画。
仕様書 `docs/TriTask_RPG_Remake_SPEC.md` の Phase 1 に対応。

---

## 0. 前提条件（変更不可の制約）

App Store / Google Play へ**アップデートとして配信**するため、以下は**絶対に変えない**。

| 項目 | 現状値 | 扱い |
|---|---|---|
| iOS Bundle ID | `com.yuuki.triTask` | 維持必須 |
| Android applicationId | `com.tritask.tri_task` | 維持必須 |
| Android namespace | `com.tritask.tri_task` | 維持必須 |
| Flutter package name (`pubspec.yaml`の`name`) | `tri_task` | 維持推奨（変更すると全import書き換え） |
| iOS/Android のフォルダ構成 | 既存 | 維持（署名・アイコン設定を保全） |

### 変更するもの

| 項目 | 旧 | 新 |
|---|---|---|
| `CFBundleDisplayName` (iOS) | `Tri Task` | `Daily Quest` |
| `android:label` (AndroidManifest) | `tri_task` | `Daily Quest` |
| `pubspec.yaml` の `description` | TriTask説明文 | Daily Quest説明文 |
| `version` | `1.0.0+1` | `2.0.0+2` |
| アプリアイコン | パステル可愛い系 | レトロRPG風 |
| `lib/` 配下のコード | 旧TriTask実装 | 全削除 → 新規構築 |

---

## 1. MVPスコープ

仕様書 §7 の MVP 実装機能 10項目に絞る。

### 入れるもの
1. 今日のメインクエストを1つ登録
2. サイドクエストを2つまで登録
3. クエストの完了・未完了切り替え
4. 完了時にEXP獲得
5. レベルとEXPバー表示
6. 連続冒険日数（メインクエスト達成日でカウント）
7. 今週のボス表示
8. メインクエスト達成でボスHP-1
9. 冒険記録の閲覧（カレンダー）
10. レトロRPG風UI・基本演出

### 入れないもの（Phase 2以降）
- 称号・宝箱演出
- バトルシステム
- 職業・装備・ガチャ
- ログイン・クラウド同期
- ウィジェット・Apple Watch
- SNSシェア（旧アプリにあったが一旦廃止）
- ダークモード・テーマ切替
- 課金（Pro版）

---

## 2. データモデル

すべて Hive でローカル保存。仕様書 §20 を Dart/Freezed 形式に変換。

### Quest
```dart
@freezed
class Quest {
  String id;                  // uuid
  String title;
  QuestType type;             // main | side
  String date;                // yyyy-MM-dd（今日のクエストの日付）
  bool isCompleted;
  DateTime? completedAt;
  String? memo;               // MVPでは未使用
  RepeatType repeatType;      // none | daily（MVPは none固定でも可）
  DateTime createdAt;
}

enum QuestType { main, side }
enum RepeatType { none, daily }
```

### UserStatus（シングルトン）
```dart
@freezed
class UserStatus {
  int level;                  // 初期1
  int exp;                    // 現レベル内のEXP
  int totalExp;               // 累計EXP
  int streakDays;             // 連続冒険日数
  String? lastCompletedDate;  // 最後にメインクエスト達成した日付 yyyy-MM-dd
}
```

### Boss（週ごとに1体）
```dart
@freezed
class Boss {
  String id;                  // uuid
  String name;                // ボス名（プリセットからランダム）
  int maxHp;                  // 7（メイン7日達成想定）
  int currentHp;
  String weekStartDate;       // yyyy-MM-dd（月曜）
  String weekEndDate;         // yyyy-MM-dd（日曜）
  String imageKey;            // assets/boss/xxx.png のキー
  bool defeated;
}
```

### AdventureRecord（日ごとに1件）
```dart
@freezed
class AdventureRecord {
  String date;                // yyyy-MM-dd
  bool mainQuestCompleted;
  int sideQuestCompletedCount;
  int gainedExp;
  bool isPerfect;             // メイン+サイド2全達成
}
```

### Hive Box 構成
- `quests` (Box<Quest>) — keyはQuest.id
- `userStatus` (Box<UserStatus>) — key固定 `'singleton'`
- `bosses` (Box<Boss>) — keyはweekStartDate
- `records` (Box<AdventureRecord>) — keyはdate

---

## 3. ロジック仕様

### EXP / レベル計算
```
メインクエスト達成: +50 EXP
サイドクエスト達成: +20 EXP
全達成（メイン+サイド2件）: +30ボーナスEXP
1日最大: 120 EXP

レベルアップ閾値: 100 EXP / level（MVPは固定）
レベルアップ時、currentExpは余剰分を持ち越し
```

### 連続冒険日数
- メインクエスト達成日のみカウント
- 前日の `lastCompletedDate` が「昨日」なら streak+1
- 「2日以上前」なら streak=1（リセット後の初日）
- 同日中に複数回トグルしても1日1回のみカウント

### 週ボス
- 週開始日（月曜0:00）にBoss新規生成
- HP=7 固定
- メインクエスト達成でcurrentHp -= 1
- 週終了時：HP0なら討伐、残ってれば「逃した」扱い
- ボス名・画像はプリセットからランダム選定（4〜6種を初期実装）

### クエスト完了取り消し
- 取り消し可能だが、EXPとストリークは戻さない（旧アプリと同じ挙動：`completedMain` フラグで二重カウント防止）

---

## 4. 画面構成

### 4タブ構成（仕様書§8）
| タブ | アイコン | スクリーン |
|---|---|---|
| 冒険 | 剣 | `QuestScreen` (今日のクエスト) |
| 記録 | 巻物 | `RecordScreen` (冒険記録カレンダー) |
| ボス | 城 | `BossScreen` (週ボス詳細) |
| 設定 | 歯車 | `SettingsScreen` |

### 各画面の構成要素

#### `QuestScreen`（メイン画面）
- ヘッダー: "今日のクエスト" + サブコピー
- ステータスカード: アバター/Lv/EXPバー/連続日数
- メインクエストカード: 1件（チェックボックス）
- サイドクエストカード: 最大2件
- 週ボスカード（簡易）: 名前・HPバー
- FAB「クエストを追加」 → `QuestEditSheet`

#### `QuestEditSheet`（追加・編集モーダル）
- クエスト名入力
- 種類選択: メイン / サイド
- (MVP) `今日だけ` のみ実装、繰り返しはPhase 2へ

#### `RecordScreen`（冒険記録）
- 月単位カレンダー
- 各日に状態表示:
  - 完全達成日: 星マーク
  - メインのみ達成: 焚き火アイコン
  - 未達成: 薄表示
- 月の合計EXP・レベル推移を上部に表示

#### `BossScreen`（週ボス）
- 大きめのボス画像
- 名前・HPバー
- 「今週の討伐進捗」テキスト
- 過去のボス討伐履歴（簡易リスト）

#### `SettingsScreen`
- 通知ON/OFF
- 効果音・バイブON/OFF（MVPはスタブでも可）
- データリセット
- 利用規約・プライバシーポリシー
- アプリについて（バージョン表示）

---

## 5. UIテーマ・デザイン

### カラーパレット（仕様書§9 を Dart定数化）
```dart
class AppColors {
  static const Color navy       = Color(0xFF1E2A4A);  // 背景
  static const Color cream      = Color(0xFFF5E6C8);  // カード背景（羊皮紙）
  static const Color gold       = Color(0xFFD4A93B);  // 装飾・強調
  static const Color blue       = Color(0xFF4A7BC5);  // CTAボタン・EXPバー
  static const Color purple     = Color(0xFF7E57C2);  // ボス系
  static const Color brown      = Color(0xFF5D3A1A);  // 本文・枠線
  static const Color crimson    = Color(0xFFB54B4B);  // ボスHP・警告
}
```

### フォント
- 本文: Noto Sans JP（旧アプリと同じ、可読性優先）
- 見出し・装飾: ピクセルフォント（候補: `PixelMplus`、`Press Start 2P` など要検討）
  - **MVP暫定**: Noto Sans JP のみで進め、Phase 2でピクセルフォント導入

### 装飾要素
- 角丸: 12px（旧24pxより小さく、レトロ感）
- 枠線: 2px brown
- カード: 羊皮紙風（クリーム背景 + brown枠）
- 区切り: 点線・装飾アイコン
- 影: ハードシャドウ（柔らかいblurは使わない＝ピクセル感）

### 視認性最優先（仕様書§9重要事項）
- フォント12px以下は使わない
- タップ領域は最小48x48
- 1画面の情報密度を抑える

---

## 6. ディレクトリ構成（lib/配下）

```
lib/
├── main.dart                          # エントリポイント・初期化
├── app.dart                           # MaterialApp + ルート構成
├── core/
│   ├── theme/
│   │   ├── app_colors.dart
│   │   ├── app_text_styles.dart
│   │   └── app_theme.dart
│   ├── constants/
│   │   ├── exp_constants.dart        # EXP値・レベル閾値
│   │   ├── boss_constants.dart       # ボスプリセット
│   │   └── app_constants.dart
│   └── utils/
│       ├── date_helper.dart          # 旧アプリから流用
│       └── week_helper.dart          # 週開始日計算
├── data/
│   ├── models/
│   │   ├── quest.dart
│   │   ├── user_status.dart
│   │   ├── boss.dart
│   │   └── adventure_record.dart
│   ├── adapters/                      # Hive TypeAdapter
│   │   └── (各モデルの.g.dart)
│   └── repositories/
│       ├── quest_repository.dart
│       ├── user_status_repository.dart
│       ├── boss_repository.dart
│       └── record_repository.dart
├── services/
│   ├── hive_service.dart             # 旧アプリパターン流用
│   ├── notification_service.dart     # 旧アプリから移植
│   └── migration_service.dart        # 旧Box削除＋初回起動フラグ
├── providers/                         # Riverpod
│   ├── quest_provider.dart
│   ├── user_status_provider.dart
│   ├── boss_provider.dart
│   └── record_provider.dart
├── features/
│   ├── quest/
│   │   ├── quest_screen.dart
│   │   ├── widgets/
│   │   │   ├── status_card.dart
│   │   │   ├── main_quest_card.dart
│   │   │   ├── side_quest_card.dart
│   │   │   ├── boss_summary_card.dart
│   │   │   └── quest_edit_sheet.dart
│   ├── record/
│   │   ├── record_screen.dart
│   │   └── widgets/
│   │       └── adventure_calendar.dart
│   ├── boss/
│   │   ├── boss_screen.dart
│   │   └── widgets/
│   │       └── boss_detail_card.dart
│   ├── settings/
│   │   └── settings_screen.dart
│   └── onboarding/
│       └── remake_announce_screen.dart  # 旧ユーザー向け案内
└── widgets/                           # 横断利用
    ├── exp_bar.dart
    ├── hp_bar.dart
    ├── parchment_card.dart            # 羊皮紙カード基底
    └── pixel_button.dart
```

---

## 7. 依存パッケージ（`pubspec.yaml` 変更案）

### 維持
```yaml
flutter_riverpod: ^2.6.1
riverpod_annotation: ^2.6.1
hive: ^2.2.3
hive_flutter: ^1.1.0
flutter_local_notifications: ^18.0.1
timezone: ^0.9.4
google_fonts: ^6.2.1
flutter_animate: ^4.5.0
uuid: ^4.5.1
intl: ^0.19.0
freezed_annotation: ^2.4.4
json_annotation: ^4.9.0
```

### 削除
```yaml
confetti: ^0.7.0          # 達成演出は別形式に
url_launcher: ^6.3.1       # SNSシェア廃止
```

### 追加候補（MVPで判断）
```yaml
table_calendar: ^3.1.2     # 冒険記録カレンダー用
flutter_svg: ^2.0.10       # ピクセルアート風アイコン
```

### dev_dependencies は据え置き

---

## 8. 旧データ移行（クリーンスタート方針）

ユーザーが v1 → v2 にアップデートした際の処理。

### `MigrationService.runOnFirstLaunchOfV2()`
1. SharedPreferences で `'v2_migrated'` フラグを確認
2. フラグがない場合：
   - 旧Hive Box を削除：`tasks`, `daily_plans`, `settings` など全旧Box
   - 旧通知を全キャンセル：`flutter_local_notifications` の `cancelAll`
   - フラグを立てる
   - 「リニューアル告知画面」を1回表示
3. 以降は通常起動

### 「リニューアル告知画面」`RemakeAnnounceScreen`
- "TriTaskが Daily Quest にリニューアルしました！"
- 主な変更点を3つ程度
- 「冒険を始める」ボタンで `QuestScreen` へ
- リリースノートにも同内容を記載

---

## 9. 実装順序（推奨ステップ）

### Step 0: プロジェクト準備（30分）
- [ ] `lib/` 配下を全削除（`main.dart` のみ空シェル化）
- [ ] `pubspec.yaml` 更新（name維持、description/version/依存を変更）
- [ ] iOS `Info.plist` の `CFBundleDisplayName` を `Daily Quest` に変更
- [ ] Android `AndroidManifest.xml` の `android:label` を `Daily Quest` に変更
- [ ] `flutter pub get` 実行確認
- [ ] コミット: "chore: clean lib, rename app to Daily Quest"

### Step 1: 基盤レイヤ（半日）
- [ ] `core/theme/` 一式（カラー・テキストスタイル・テーマ）
- [ ] `core/constants/` 一式
- [ ] `core/utils/date_helper.dart`、`week_helper.dart`
- [ ] `services/hive_service.dart`（Box初期化）
- [ ] `services/migration_service.dart`（クリーンスタート処理）
- [ ] `main.dart` で初期化シーケンスを組む
- [ ] コミット: "feat: scaffold core/theme/services"

### Step 2: データ層（半日）
- [ ] 4つのモデル定義（freezed）
- [ ] `build_runner` 実行 → `.g.dart`/`.freezed.dart` 生成
- [ ] Hive TypeAdapter 登録
- [ ] 4つの Repository 実装
- [ ] コミット: "feat: data models and repositories"

### Step 3: 状態管理層（半日）
- [ ] 4つの Riverpod Provider
- [ ] Provider間の連携ロジック（Quest完了 → UserStatus更新 → Boss更新 → Record記録）
- [ ] 単体テスト（Provider単位、最低限）
- [ ] コミット: "feat: riverpod providers with completion flow"

### Step 4: 共通Widget（半日）
- [ ] `parchment_card.dart`
- [ ] `exp_bar.dart`、`hp_bar.dart`
- [ ] `pixel_button.dart`
- [ ] コミット: "feat: shared RPG-themed widgets"

### Step 5: メイン画面（1日）
- [ ] `QuestScreen` レイアウト構築
- [ ] `StatusCard`, `MainQuestCard`, `SideQuestCard`, `BossSummaryCard`
- [ ] `QuestEditSheet`
- [ ] 完了アニメーション・トースト
- [ ] FAB → 追加フロー
- [ ] コミット: "feat: quest screen MVP"

### Step 6: 残り3画面（1日）
- [ ] `RecordScreen` + カレンダー
- [ ] `BossScreen`
- [ ] `SettingsScreen`
- [ ] 4タブ統合 (`app.dart`)
- [ ] コミット: "feat: record/boss/settings screens"

### Step 7: 通知・移行・告知画面（半日）
- [ ] `notification_service.dart` 移植 + 新文言
- [ ] `migration_service.dart` 完成
- [ ] `RemakeAnnounceScreen`
- [ ] コミット: "feat: notifications, migration, announce screen"

### Step 8: 仕上げ（1日）
- [ ] iOS実機/シミュレータ動作確認
- [ ] Android実機/エミュレータ動作確認
- [ ] アイコン差し替え（要素材）
- [ ] スプラッシュ更新
- [ ] バージョン番号確定
- [ ] コミット: "chore: final assets and version bump"

**合計工数の目安: 5〜6営業日**

---

## 10. テスト戦略

MVPは網羅率より**核となるロジックの正しさ**を優先。

### 必須テスト（Step 3 と並行）
- `UserStatusProvider`: EXP加算とレベルアップ境界（99→100→101）
- `UserStatusProvider`: ストリーク計算（昨日達成 / 一昨日達成 / 同日重複）
- `BossProvider`: 週開始時のボス生成、HP減算、討伐判定
- `QuestProvider`: 同日のメイン1件制約、サイド2件上限

### 任意（時間あれば）
- Widget テスト: `QuestScreen` の3カード表示
- 統合テスト: メインクエスト達成 → ボスHP-1 → Record保存

### 手動QA（Step 8）
- iOS / Android 両方で：
  - 旧v1から起動 → 移行画面 → 旧データ消失確認
  - クエスト追加・完了・取り消し
  - レベルアップ
  - 通知の発火
  - 翌日の挙動（デバッグ用に日付変更）
  - ボス討伐 → 翌週新ボス

---

## 11. リスクと対処

| リスク | 対処 |
|---|---|
| 旧ユーザーから「データが消えた」と低評価 | リリースノート明示 + 告知画面で説明 + ストア審査時にも記載 |
| ピクセルフォント未調達でMVP延期 | MVPはNoto Sans JPで進め、Phase 2で差し替え |
| ボス画像素材の調達 | 仮素材でMVP進行、リリース前に確定 |
| 通知タップからクエスト追加への導線 | 旧アプリと同方式（`payload` で画面振り分け） |
| Hive Box破損時のクラッシュ | `try/catch` + 破損時は全削除して再生成 |
| App Store審査でリブランドを疑問視 | 「同一機能の大幅アップデート」と説明文に明記 |

---

## 12. このMVP完了後の Phase 2 候補

Phase 1 完了後、ユーザー反応を見ながら優先順位を決める：
- 達成演出強化（宝箱開封アニメ・効果音）
- 称号システム
- ピクセルフォント・アイコン本実装
- ダークモード（ナイトテーマ）
- ボス種類の拡張
- 詳細統計画面
- 通知文言バリエーション

---

## 13. このドキュメントの位置づけ

- **仕様書**: `docs/TriTask_RPG_Remake_SPEC.md`（What・Why）
- **本書**: `docs/Daily_Quest_MVP_PLAN.md`（How・順序・MVPスコープ）
- **進捗管理**: TaskCreate ツールでステップごとに追跡

仕様書に矛盾があれば仕様書を真とし、本書を更新する。
