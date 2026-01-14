// Views/Rename/Preview/RenamePreviewView.swift
//
// Rename 一覧・編集画面（State 駆動・v0.2）
// - RenameFlowState.preview に完全対応
// - ViewModel を持たない
// - 一覧表示 / 選択 / 編集 / Apply 遷移のみを責務とする
//

import SwiftUI

struct RenamePreviewView: View {

    // MARK: - Inputs（RenameFlowState.preview と 1:1）

    let rootURL: URL
    let plans: [RenamePlan]
    let selectionIndex: Int?
    let showSpaceMarkers: Bool

    let onSelect: (Int?) -> Void
    let onUpdateName: (Int, String) -> Void
    let onApply: () -> Void
    let onCancel: () -> Void

    // MARK: - View

    var body: some View {
        VStack(spacing: 0) {

            header

            Divider()

            list

            Divider()

            footer
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            Text("Apply Preview")
                .font(.headline)

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Button("フォルダを選択") {
                    onCancel()
                }
                .buttonStyle(.bordered)

                Text("\(plans.count) 件のリネーム候補")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
    }

    // MARK: - List

    private var list: some View {
        ScrollViewReader { proxy in
            List(plans.indices, id: \.self, selection: selectionBinding) { index in
                RenamePreviewRow(
                    plan: plans[index],
                    isSelected: selectionIndex == index,
                    showSpaceMarkers: showSpaceMarkers,
                    onCommit: { newName in
                        onUpdateName(index, newName)
                    },
                    onCancel: {
                        onSelect(nil)
                    }
                )
                .tag(index)
                .listRowInsets(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
            }
            .listStyle(.plain)
            .onChange(of: selectionIndex) { _, newValue in
                guard let index = newValue else { return }
                withAnimation(.easeInOut(duration: 0.15)) {
                    proxy.scrollTo(index, anchor: .center)
                }
            }
        }
    }

    private var selectionBinding: Binding<Set<Int>> {
        Binding(
            get: {
                selectionIndex.map { [$0] } ?? []
            },
            set: { newValue in
                onSelect(newValue.first)
            }
        )
    }

    // MARK: - Footer

    private var footer: some View {
        HStack {
            Button("閉じる") {
                onCancel()
            }
            .keyboardShortcut(.cancelAction)

            Spacer()

            Button("適用") {
                onApply()
            }
            .keyboardShortcut(.defaultAction)
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
