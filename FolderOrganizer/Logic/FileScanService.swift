// Logic/FileScanService.swift
import Foundation

struct FileScanService {

    /// デバッグ・UIプレビュー用
    static func loadSampleNames() -> [RenameItem] {
        let samples: [String] = [
            "【同人誌】【黒山羊×工玉】元カレのデカチンが忘れられないの？（オリジナル）【DL版】",
            "【diletta】愛獣に飢えた渋谷令嬢をメス堕ちさせるまで飼いならし、堕ろ。",
            "【立花ナミ】異世界ハーレム物語 vol.2.5",
            "【あいさわひろり】",
            "【成年コミック】【猫夜】あげちん♂〜美女たちにSEXしてとせがまれて〜【DL版】"
        ]

        return samples.map { name in
            let result = NameNormalizer.normalize(name)

            return RenameItem(
                original: name,
                normalized: result.normalizedName,
                edited: "",
                flagged: false
            )
        }
    }
}
