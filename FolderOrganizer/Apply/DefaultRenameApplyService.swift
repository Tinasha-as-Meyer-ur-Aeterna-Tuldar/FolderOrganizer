import Foundation

final class DefaultRenameApplyService: RenameApplyService {

    private let fileSystem: FileSystem

    init(fileSystem: FileSystem = RealFileSystem()) {
        self.fileSystem = fileSystem
    }

    func apply(_ plan: RenamePlan) -> ApplyResult {

        let sourceURL = plan.originalURL
        let destinationParent = plan.targetParentFolder
        let destinationURL = destinationParent
            .appendingPathComponent(plan.targetName)

        // 1. 親フォルダ作成
        if !fileSystem.fileExists(at: destinationParent) {
            do {
                try fileSystem.createDirectory(at: destinationParent)
            } catch {
                return ApplyResult(
                    plan: plan,
                    success: false,
                    appliedURL: nil,
                    error: .failedToCreateDirectory(destinationParent)
                )
            }
        }

        // 2. 重複チェック
        if fileSystem.fileExists(at: destinationURL) {
            return ApplyResult(
                plan: plan,
                success: false,
                appliedURL: nil,
                error: .destinationAlreadyExists(destinationURL)
            )
        }

        // 3. 移動
        do {
            try fileSystem.moveItem(
                from: sourceURL,
                to: destinationURL
            )

            return ApplyResult(
                plan: plan,
                success: true,
                appliedURL: destinationURL,
                error: nil
            )
        } catch {
            return ApplyResult(
                plan: plan,
                success: false,
                appliedURL: nil,
                error: .failedToMoveItem(
                    from: sourceURL,
                    to: destinationURL,
                    underlying: error
                )
            )
        }
    }
}
