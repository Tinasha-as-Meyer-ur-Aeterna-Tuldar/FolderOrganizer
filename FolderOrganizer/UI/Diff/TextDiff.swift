import Foundation

enum TextDiff {

    static func diff(
        before: String,
        after: String
    ) -> [DiffSegment] {

        let beforeTokens = tokenize(before)
        let afterTokens = tokenize(after)

        var result: [DiffSegment] = []

        var i = 0
        var j = 0

        while i < beforeTokens.count || j < afterTokens.count {

            if i < beforeTokens.count,
               j < afterTokens.count,
               beforeTokens[i] == afterTokens[j] {

                result.append(
                    DiffSegment(
                        text: beforeTokens[i],
                        type: .unchanged
                    )
                )
                i += 1
                j += 1
            }
            else {
                if i < beforeTokens.count {
                    result.append(
                        DiffSegment(
                            text: beforeTokens[i],
                            type: .removed
                        )
                    )
                    i += 1
                }

                if j < afterTokens.count {
                    result.append(
                        DiffSegment(
                            text: afterTokens[j],
                            type: .added
                        )
                    )
                    j += 1
                }
            }
        }

        return result
    }

    // MARK: - Tokenize

    /// 文字列を「意味を壊さない単位」に分解
    private static func tokenize(_ text: String) -> [String] {

        var tokens: [String] = []
        var current = ""

        for char in text {
            if char.isWhitespace {
                if !current.isEmpty {
                    tokens.append(current)
                    current = ""
                }
                tokens.append(String(char))
            }
            else if "[]()（）".contains(char) {
                if !current.isEmpty {
                    tokens.append(current)
                    current = ""
                }
                tokens.append(String(char))
            }
            else {
                current.append(char)
            }
        }

        if !current.isEmpty {
            tokens.append(current)
        }

        return tokens
    }
}
