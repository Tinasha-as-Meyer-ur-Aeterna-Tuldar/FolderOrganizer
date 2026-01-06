//
//  RenameImportError.swift
//  FolderOrganizer
//

import Foundation

enum RenameImportError: Error {
    case decodeFailed(Error)
    case unsupportedVersion
    case missingRootFolder
}
