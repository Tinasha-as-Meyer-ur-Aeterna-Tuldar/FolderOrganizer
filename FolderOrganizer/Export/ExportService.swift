import Foundation

final class ExportService {

    private let encoder: JSONEncoder

    init(encoder: JSONEncoder = ExportEncoder.makeJSONEncoder()) {
        self.encoder = encoder
    }

    // MARK: - RenamePlan

    func exportRenamePlans(
        _ plans: [RenamePlan],
        to url: URL
    ) throws {

        let exports = plans.map {
            RenamePlanExport(from: $0)
        }

        let data = try encoder.encode(exports)
        try data.write(to: url)
    }

    // MARK: - ApplyResult

    func exportApplyResults(
        _ results: [ApplyResult],
        to url: URL
    ) throws {

        let exports = results.map {
            ApplyResultExport(from: $0)
        }

        let data = try encoder.encode(exports)
        try data.write(to: url)
    }
}
