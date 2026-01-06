//
//  RenameImportMapper.swift
//  FolderOrganizer
//

import Foundation

enum RenameImportMapper {

    static func map(doc: RenameExportDocument) -> [RenamePlan] {
        doc.items.map { $0.toDomain() }
    }
}
