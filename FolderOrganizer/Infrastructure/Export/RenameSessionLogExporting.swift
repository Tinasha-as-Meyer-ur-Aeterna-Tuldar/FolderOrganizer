// Infrastructure/Export/RenameSessionLogExporting.swift
//
// RenameSessionLog を永続化する責務の抽象
//

import Foundation

protocol RenameSessionLogExporting {
    func export(log: RenameSessionLog) throws
}
