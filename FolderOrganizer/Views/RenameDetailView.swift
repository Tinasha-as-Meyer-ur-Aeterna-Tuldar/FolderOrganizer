// Views/RenameDetailView.swift
import SwiftUI

/// 選択行の詳細・編集ポップアップ
///
/// ✅ STEP C-2
/// - `RenameItem` を @Binding で受け取り、編集が即時に一覧へ反映されるようにする
/// - `item.edited` が「最終的に採用する新名」
struct RenameDetailView: View {

    // 🔴 ここが C-2 の肝：値渡しではなく Binding
    @Binding var item: RenameItem

    let index: Int
    let total: Int
    let onPrev: () -> Void
    let onNext: () -> Void
    let onClose: () -> Void

    @FocusState private var isEditorFocused: Bool

    // 一覧と同じ判定で背景色を決める（編集後の文字列で判定）
    private var detailBackground: Color {
        if item.isSubtitle {
            return AppTheme.colors.subtitleBackground
        }
        if item.isPotentialSubtitle {
            return AppTheme.colors.potentialSubtitleStrong
        }
        return AppTheme.colors.cardBackground
    }

    var body: some View {

        ZStack(alignment: .topTrailing) {

            VStack(alignment: .leading, spacing: 18) {

                // 閉じるボタンと内容の間に少し余白を作る
                Spacer().frame(height: 14)

                // 旧
                HStack(alignment: .top, spacing: 6) {
                    Text("旧:")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(AppTheme.colors.oldText)
                    Text(item.original)
                        .font(.system(size: 17))
                        .foregroundColor(AppTheme.colors.oldText)
                        .fixedSize(horizontal: false, vertical: true)
                }

                // 提案（自動正規化）
                HStack(alignment: .top, spacing: 6) {
                    Text("提案:")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(AppTheme.colors.checkLabel)

                    DiffBuilder.highlightSpaces(in: item.normalized)
                        .font(.system(size: 14))
                        .foregroundColor(AppTheme.colors.checkLabel)
                        .fixedSize(horizontal: false, vertical: true)
                }

                // 編集（ここで打った内容が即時に一覧へ反映される）
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 6) {
                        Text("編集:")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(AppTheme.colors.newText)

                        if item.isModified {
                            Text("(変更あり)")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(AppTheme.colors.newText)
                                .opacity(0.8)
                        }

                        Spacer()

                        // ワンクリックで提案に戻す（Undo 的な最小ユーティリティ）
                        Button {
                            item.edited = item.normalized
                        } label: {
                            Text("提案に戻す")
                                .font(.system(size: 12, weight: .semibold))
                        }
                        .buttonStyle(.bordered)
                        .tint(AppTheme.colors.primaryButton)
                    }

                    TextField("新しい名前を編集…", text: $item.edited)
                        .textFieldStyle(.roundedBorder)
                        .font(.system(size: 15))
                        .focused($isEditorFocused)
                        .onSubmit {
                            // Enter で編集確定…というより「入力フォーカスを外す」程度
                            //（リアルタイム反映は Binding が担う）
                            isEditorFocused = false
                        }

                    // 新（編集結果のプレビュー：スペース可視化付き）
                    HStack(alignment: .top, spacing: 6) {
                        Text("新:")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(AppTheme.colors.newText)

                        DiffBuilder.highlightSpaces(in: item.currentNewName)
                            .font(.system(size: 17))
                            .foregroundColor(AppTheme.colors.newText)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }

                Spacer()

                // 右下に上下ボタン
                HStack {
                    Spacer()
                    VStack(spacing: 12) {
                        Button(action: onPrev) {
                            Image(systemName: "arrow.up.circle.fill")
                                .resizable()
                                .frame(width: 32, height: 32)
                                .foregroundColor(AppTheme.colors.primaryButton)
                        }
                        .buttonStyle(.plain)

                        Button(action: onNext) {
                            Image(systemName: "arrow.down.circle.fill")
                                .resizable()
                                .frame(width: 32, height: 32)
                                .foregroundColor(AppTheme.colors.primaryButton)
                        }
                        .buttonStyle(.plain)
                    }
                }

                // 中央に「n / N」
                HStack {
                    Spacer()
                    Text("\(index + 1) / \(total)")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.black)
                    Spacer()
                }
            }
            .padding(26)

            // 右上の × ボタン（ポップアップ内）
            Button(action: onClose) {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 26, height: 26)
                    .foregroundColor(.gray.opacity(0.9))
            }
            .buttonStyle(.plain)
            .padding(12)
        }
        .background(detailBackground)
        .cornerRadius(18)
        .shadow(radius: 14)
        .frame(width: 760, height: 480)
        .onAppear {
            // 開いたらすぐ編集できるようにフォーカス
            DispatchQueue.main.async {
                isEditorFocused = true
            }
        }
    }
}
