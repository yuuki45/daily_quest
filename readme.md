要件定義書：シンプルで可愛いTODOリストアプリ
1. アプリ概要

名称：TriTask（トライタスク）
「TriTask」という名前には、“3つのタスク”“Try + Task（挑戦）”“Tri＝三位一体”など、いくつもの良い語感が含まれています。

目的：ユーザーが毎日「3つだけ」のタスクに集中し、楽しく習慣化できるように支援する。

特徴：

シンプルかつ可愛いUI/UX

21:00の通知で「明日の3つ」を決めさせる

Streak（連続達成日数）＋育成UI（植物成長）

達成後のSNSシェア（X連携）

2. 対象ユーザー

日々のToDo管理をシンプルにしたい人

可愛いデザインやアニメーションでモチベ維持したい人

習慣化を目指す社会人・学生

3. 機能要件
3.1 コア機能

タスク管理

1日のタスク数は固定で「3つ」

バックログ（未完了タスク）から選択 or 新規追加

完了時にぷにっと弾むアニメーション＋効果音

プランニング

毎日21:00に通知

通知タップ → プラン編集シートを表示

翌日の「3つ」を決めさせるUX

Streak / 育成UI

3/3達成で Streak +1

未達成で Streakリセット

段階的成長UI（種🌱 → 芽🌿 → 蕾🌼 → 花🌸 → 花束💐）

SNSシェア

3/3達成時に「Xでシェア」ボタン表示

プリセット文：

今日の3つ、ぜんぶ達成！
・タスク1
・タスク2
・タスク3
#TriTask

3.2 補助機能

タグ管理（Work/Life/Study/Health/Other）

ローカル通知（flutter_local_notifications）

ローカル保存（Hive）

ダークモード対応（後日）

4. UIデザイン

UI/UX

ニューモーフィズム風＋角丸24px

パステル系カラー（背景 #F6F7FB、アクセント #5B8CFF）

フォント：Noto Sans JP

パフォーマンス

オフライン完結（ネット不要）

起動時間：2秒以内

プラットフォーム

Flutter製 → iOS / Android両対応

5. データモデル
Task
Task {
  id: string
  title: string
  tag?: string
  due?: Date
  done: boolean
  createdAt: Date
  archived: boolean
}

DailyPlan
DailyPlan {
  date: string
  plannedTaskIds: string[] // 最大3
  completedAll: boolean
  streakCount: number
  plantStage: 0|1|2|3|4
}

6. 画面仕様

Today画面

今日の3タスク表示（3枠固定）

Streak/植物UI表示

完了後 → Xシェアボタン

PlanEditor（シート）

バックログから最大3件を選択

新規追加も可能

Allタスク画面

未完了タスク一覧

検索/削除

Settings

通知ON/OFF

効果音ON/OFF

テーマ切替

7. 通知仕様

時間：毎日21:00

メッセージ：「明日の3つを決めよう」

タップ時：PlanEditorシートを直接表示

8. 今後の拡張

ガチャ的ご褒美UI（スタンプ/シール）
