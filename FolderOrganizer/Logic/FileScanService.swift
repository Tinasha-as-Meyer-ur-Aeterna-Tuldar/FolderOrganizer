import Foundation

struct FileScanService {

    static func loadSampleNames() -> [RenameItem] {
        let samples = [
            "(同人誌) [たつわの里 (タツワイプ)] デリヘル呼んだら元同級生が来た～ポリネシアンセックス編～ (オリジナル)",
            "(同人誌) [たつわの里 (タツワイプ)] デリヘル呼んだら元同級生が来た 2 (オリジナル)",
            "(同人誌) [まかろんシュガー] 童貞大好き女学生ちゃん、絶倫童貞に敗北するーThird Time is Fateー (オリジナル)",
            "[あおやまきいろ。] シスターガーデン 姉の膣内に射精して、妹の膣内にも射精した。",
            "[しゅにち] ガチハメSEX指導 3",
            "(成年コミック) [猫夜] あげちん♂ ～美女たちにSEXしてとせがまれて～ [DL版]",
            "(C100) [い～ぐるらんど (鷹丸)] 一途な彼女が堕ちる瞬間 (オリジナル) [DL版]"
        ]

        return samples.map { name in
            let norm = NameNormalizer.normalize(name)
            return RenameItem(
                original: norm.original,
                normalized: norm.displayName,
                flagged: false
            )
        }
    }
}
