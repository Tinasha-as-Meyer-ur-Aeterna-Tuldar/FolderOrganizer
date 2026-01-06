//
//  KeyPress.swift
//  FolderOrganizer
//
//  macOS 用: キー入力（Enter / Esc 等）を拾うためのヘルパー
//
//  ✅ 今回の修正ポイント
//  - extension View の中に enum/struct をネストしない（コンパイルエラー回避）
//  - ファイルスコープ型 + View拡張は「関数だけ」
//

import SwiftUI
import AppKit

// MARK: - Result

enum KeyPressResult {
    case handled
    case ignored
}

// MARK: - NSView that captures keyDown

final class KeyCatcherView: NSView {

    var onKeyDown: ((NSEvent) -> Bool)?

    override var acceptsFirstResponder: Bool { true }

    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        // 背景として置かれても responder になれるようにする
        DispatchQueue.main.async { [weak self] in
            self?.window?.makeFirstResponder(self)
        }
    }

    override func keyDown(with event: NSEvent) {
        if onKeyDown?(event) == true { return }
        super.keyDown(with: event)
    }
}

// MARK: - SwiftUI bridge

struct KeyPressView: NSViewRepresentable {

    let key: KeyEquivalent
    let perform: () -> KeyPressResult

    func makeNSView(context: Context) -> NSView {
        let view = KeyCatcherView()
        view.onKeyDown = { event in
            guard let chars = event.charactersIgnoringModifiers, chars.count == 1 else {
                return false
            }
            let pressed = KeyEquivalent(Character(chars))
            guard pressed == key else { return false }

            return perform() == .handled
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        // no-op
    }
}

// MARK: - View extension (関数だけ)

extension View {

    /// 指定キーを押したら perform を呼ぶ（handled ならそこで止める）
    func onKeyPress(_ key: KeyEquivalent, perform: @escaping () -> KeyPressResult) -> some View {
        background(KeyPressView(key: key, perform: perform))
    }
}
