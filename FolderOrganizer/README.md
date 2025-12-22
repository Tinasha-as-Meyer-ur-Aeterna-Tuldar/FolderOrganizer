# FolderOrganizer

macOS 向けのフォルダ名整理・リネーム支援アプリです。  
単純な一括リネームではなく、**「意図が分かる変換プレビュー」**と  
**安全な適用フロー**を重視しています。

---

## 目的

- フォルダ名の揺れ（全角/半角/スペース/記号）を整理したい
- 自動変換だけでなく「人の判断」を途中に挟みたい
- 実行前に変更内容を **視覚的に確認** したい
- 将来的に Undo / 再適用 / 学習につなげたい

---

## アーキテクチャ概要

本プロジェクトは、責務を明確に分離した構成を採用しています。

App            : アプリ全体の入口・背景・トーン
Views          : 画面/UI（SwiftUI）
Domain         : 意味を持つデータ構造
Logic          : 計算・判定ロジック
Infrastructure : ファイル操作など実処理

---

## Views 構成

### Views/Common

複数画面で再利用される **純粋な UI コンポーネント**。

- `SpaceMarkerTextView`  
  半角/全角スペースを可視化する表示 View
- `DiffTextView`  
  Rename 向け差分表示（same / added / replaced）
- `CardStyle`  
  macOS らしい Card UI の共通スタイル

---

### Views/Rename

リネーム作業のメインフロー。

Views/Rename
├─ List
├─ Preview
├─ Detail
├─ Edit
└─ Apply

#### Preview Views の責務

- **PreviewListContentView**  
  Preview 一覧の中身のみを担当する View  
  （LazyVStack + ForEach）

- **PreviewRowView**  
  Preview 一覧用の互換ラッパー View。  
  実体は `RenameRowView` を再利用する。

- **RenamePreviewList**  
  Preview 一覧全体のコンテナ View  
  （ScrollView / 選択管理）

- **RenamePreviewRow**  
  Preview 固有の Card UI・選択状態の表現を担当する View

---

### Views/Rename/Detail

- **RenameDetailView**  
  旧 → 新の変換内容を Diff 表示付きで確認・編集する画面

- **MaybeSubtitleDecisionView**  
  自動判定では確定できない場合に  
  ユーザー判断を求める補助 View

---

## Diff 表示設計（Rename 特化）

Diff は Git 的な完全差分ではなく、  
**「新しい名前を読む」ための最小情報表示**を目的としています。

### Diff の種類

- `same`      : 変化なし
- `added`     : 新しく追加された文字
- `replaced`  : 置き換えられた文字

※ 削除文字は表示しません。

### 構成

- `DiffBuilder`（Logic）  
  old / new から DiffToken を生成する

- `DiffToken`（Domain）  
  差分の意味を持つデータ構造

- `DiffTextView`（Views/Common）  
  色・太字・ライト/ダーク対応を含む表示 View

---

## Domain について

Domain は **意味を持つデータ構造**を置く場所です。

- `RenameItem`
- `RenamePlan`
- `RenameWarning`
- `DiffToken / DiffSegment`

DiffToken / DiffSegment は  
**一時的な計算結果だが意味を持つドメインモデル**として  
Domain に配置しています。

---

## 設計方針（重要）

- ファイル名と struct 名を一致させ、View は必ず `View` を付ける
- ViewBuilder 内で計算を行わない（計算は外で）
- UI / Logic / Domain を混在させない
- 「将来消せる」「将来分けられる」構成を優先する

---

## 現在の状態

- Rename / Preview / Detail / Edit フローが確立
- Diff 表示（added / replaced）が安定
- ファイル構成は拡張前提で整理済み

Views/Rename
 ├─ List        // 一覧（通常リスト）
 ├─ Preview     // 変換プレビュー
 ├─ Detail      // 詳細・判断
 ├─ Edit        // 編集操作
 └─ Apply       // 適用・結果

## Apply / Undo フロー（設計メモ）

Rename の適用は、以下の段階を踏む安全設計とする。

1. Preview  
   変更内容を Diff 表示で確認する段階

2. Apply Confirmation  
   実行前にまとめて確認する段階

3. Apply Execution  
   ファイル操作を実行する段階  
   （Infrastructure に処理を委譲）

4. Result / Undo  
   実行結果を記録し、Undo 可能な状態を残す

Apply / Undo は UI・Logic・Infrastructure を分離し、
将来的な DryRun / 再実行 / ログ保存に対応できる構成とする。

## 今後の拡張メモ

- Undo / Redo
- 過去の Rename 結果の再適用
- ユーザー判断（Subtitle 等）を学習データとして蓄積
- 正規化ルールの改善ループ

これらは Domain / Logic 層に閉じる形で追加する想定。

