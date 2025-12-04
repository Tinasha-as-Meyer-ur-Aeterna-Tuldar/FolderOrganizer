import Foundation

struct DiffUtil {
    static func diff(old: String, new: String) -> String {
        var result = ""
        let maxCount = max(old.count, new.count)
        
        for i in 0..<maxCount {
            let o = i < old.count ? old[old.index(old.startIndex, offsetBy: i)] : " "
            let n = i < new.count ? new[new.index(new.startIndex, offsetBy: i)] : " "
            if o != n {
                result += "⬆︎\(o) → \(n)\n"
            }
        }
        
        return result.isEmpty ? "差分なし" : result
    }
}
