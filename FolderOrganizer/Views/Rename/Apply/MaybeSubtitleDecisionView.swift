//
//  MaybeSubtitleDecisionView.swift
//  FolderOrganizer
//
//  Subtitle として扱うかどうかをユーザーに判断させる View
//

import SwiftUI

struct MaybeSubtitleDecisionView: View {

    // MARK: - Inputs

    let originalURL: URL
    let maybeSubtitle: String

    @ObservedObject var decisionStore: SubtitleDecisionStore

    @Environment(\.dismiss)
    private var dismiss

    // MARK: - View

    var body: some View {
        VStack(spacing: 20) {

            Text("この文字列を Subtitle として扱いますか？")
                .font(.headline)

            Text(maybeSubtitle)
                .font(.title3)
                .padding()
                .background(
                    Color(nsColor: .controlBackgroundColor)
                        .cornerRadius(8)
                )

            VStack(spacing: 12) {

                Button {
                    decisionStore.setSubtitleDecision(
                        confirmAsSubtitle: true,
                        for: originalURL
                    )
                    dismiss()
                } label: {
                    Text("Subtitle にする")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)

                Button {
                    decisionStore.setSubtitleDecision(
                        confirmAsSubtitle: false,
                        for: originalURL
                    )
                    dismiss()
                } label: {
                    Text("無視する")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
            .padding(.horizontal)
        }
        .padding(24)
        .frame(minWidth: 520)
    }
}
