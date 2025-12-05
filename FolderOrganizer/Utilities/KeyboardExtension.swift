// Utilities/KeyboardExtension.swift
import SwiftUI
import AppKit

private struct KeyDownHandler: NSViewRepresentable {

    let onKeyDown: (NSEvent) -> Void

    func makeNSView(context: Context) -> NSView {
        let view = KeyView()
        view.onKeyDown = onKeyDown

        // ファーストレスポンダにする
        DispatchQueue.main.async {
            view.window?.makeFirstResponder(view)
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {}

    final class KeyView: NSView {
        var onKeyDown: ((NSEvent) -> Void)?

        override var acceptsFirstResponder: Bool { true }

        override func keyDown(with event: NSEvent) {
            onKeyDown?(event)
        }
    }
}

extension View {
    func onKeyDown(_ handler: @escaping (NSEvent) -> Void) -> some View {
        self.background(KeyDownHandler(onKeyDown: handler))
    }
}
