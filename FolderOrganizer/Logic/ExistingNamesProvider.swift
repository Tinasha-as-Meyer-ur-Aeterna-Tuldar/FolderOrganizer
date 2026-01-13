//
//  Logic/ExistingNamesProvider.swift
//  FolderOrganizer
//
//  Apply 前確認用：既存名チェック抽象化
//

import Foundation

protocol ExistingNamesProvider {
    func exists(name: String) -> Bool
}
