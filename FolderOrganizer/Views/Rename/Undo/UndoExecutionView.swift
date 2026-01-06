//
//  UndoExecutionView.swift
//  FolderOrganizer
//

import SwiftUI

struct UndoExecutionView: View {
    
    let rollback: RollbackInfo
    let undoService: RenameUndoService
    let onClose: () -> Void
    
    @State private var isExecuting: Bool = false
    @State private var results: [UndoResult] = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Undo 実行")
                .font(.headline)
            
            if isExecuting {
                ProgressView()
                    .progressViewStyle(.linear)
            }
            
            Divider()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(Array(results.enumerated()), id: \.offset) { index, result in
                        switch result {
                        case .success(let move):
                            UndoResultRowView(
                                index: index,
                                move: move
                            )

                        case .failure:
                            EmptyView() // またはエラー用Row
                        }
                    }
                }
            }
            .frame(maxHeight: 280)
            
            Divider()
            
            HStack {
                Button("閉じる") { onClose() }
                Spacer()
            }
        }
        .padding(24)
        .onAppear {
            executeUndo()
        }
    }
    
    private func executeUndo() {
        guard !isExecuting else { return }
        
        isExecuting = true
        results = []
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.undoService.undo(rollback: rollback) { result in
                DispatchQueue.main.async {
                    self.results.append(result)
                    
                    // 全 undo が終わったら完了扱い
                    if self.results.count == self.rollback.moves.count {
                        self.isExecuting = false
                    }
                }
            }
        }
    }
}
