//
//  RenameImportService.swift
//  FolderOrganizer
//

import Foundation

protocol RenameImportService {
    func `import`(data: Data) throws -> RenameImportResult
}
