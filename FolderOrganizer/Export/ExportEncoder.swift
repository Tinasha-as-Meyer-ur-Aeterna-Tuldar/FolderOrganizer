import Foundation

enum ExportEncoder {

    static func makeJSONEncoder() -> JSONEncoder {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [
            .prettyPrinted,
            .sortedKeys
        ]
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }
}
