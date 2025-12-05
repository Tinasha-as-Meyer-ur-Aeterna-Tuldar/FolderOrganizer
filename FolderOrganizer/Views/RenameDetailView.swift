// Views/RenameDetailView.swift
import SwiftUI

struct RenameDetailView: View {
    let item: RenameItem
    let index: Int
    let total: Int
    let onPrev: () -> Void
    let onNext: () -> Void
    let onClose: () -> Void

    // 一覧と同じ判定で背景色を決める
    private var detailBackground: Color {
        if TextClassifier.isSubtitle(item.normalized) {
            return AppTheme.colors.subtitleBackground
        }
        if TextClassifier.isPotentialSubtitle(item.normalized) {
            return AppTheme.colors.potentialSubtitleStrong
        }
        return AppTheme.colors.cardBackground
    }

    var body: some View {

        ZStack(alignment: .topTrailing) {

            VStack(alignment: .leading, spacing: 22) {

                // 閉じるボタンと内容の間に少し余白を作る
                Spacer().frame(height: 20)

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

                // 新
                HStack(alignment: .top, spacing: 6) {
                    Text("新:")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(AppTheme.colors.newText)
                    DiffBuilder.highlightSpaces(in: item.normalized)
                        .font(.system(size: 17))
                        .foregroundColor(AppTheme.colors.newText)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()

                // 右下に上下ボタン
                HStack {
                    Spacer()
                    VStack(spacing: 12) {
                        Button {
                            onPrev()
                        } label: {
                            Image(systemName: "arrow.up.circle.fill")
                                .resizable()
                                .frame(width: 32, height: 32)
                                .foregroundColor(AppTheme.colors.primaryButton)
                        }
                        .buttonStyle(.plain)

                        Button {
                            onNext()
                        } label: {
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
            Button {
                onClose()
            } label: {
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
        .frame(width: 720, height: 420)   // 少しコンパクトなポップアップ
    }
}
