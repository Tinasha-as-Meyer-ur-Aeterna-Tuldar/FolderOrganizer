import Foundation

final class DefaultRenameUndoService: RenameUndoService {

    private let fileSystem: FileSystem

    init(fileSystem: FileSystem = RealFileSystem()) {
        self.fileSystem = fileSystem
    }

    func undo(_ result: ApplyResult) -> UndoResult {

        guard result.success,
              let appliedURL = result.appliedURL else {
            return UndoResult(
                applyResult: result,
                success: false,
                restoredURL: nil,
                error: .notApplicable
            )
        }

        let originalURL = result.plan.originalURL

        guard fileSystem.fileExists(at: appliedURL) else {
            return UndoResult(
                applyResult: result,
                success: false,
                restoredURL: nil,
                error: .appliedItemMissing(appliedURL)
            )
        }

        if fileSystem.fileExists(at: originalURL) {
            return UndoResult(
                applyResult: result,
                success: false,
                restoredURL: nil,
                error: .originalLocationAlreadyExists(originalURL)
            )
        }

        do {
            try fileSystem.moveItem(
                from: appliedURL,
                to: originalURL
            )

            return UndoResult(
                applyResult: result,
                success: true,
                restoredURL: originalURL,
                error: nil
            )
        } catch {
            return UndoResult(
                applyResult: result,
                success: false,
                restoredURL: nil,
                error: .failedToMoveItem(
                    from: appliedURL,
                    to: originalURL,
                    underlying: error
                )
            )
        }
    }
}
