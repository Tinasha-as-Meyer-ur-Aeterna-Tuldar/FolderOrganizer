//
//  RenameExportService.swift
//  FolderOrganizer
//

import Foundation

protocol RenameExportService {

    func export(
        document: RenameExportDocument,
        to url: URL
    ) throws
}
