//
//  FileManagerService.swift
//  testTask
//
//  Created by Valerii Petrychenko on 3/27/19.
//  Copyright © 2019 Valerii Petrychenko. All rights reserved.
//

import Foundation

protocol FileManagerable {
    func write(record: Data)
    func read(from name: String) -> URL?
    func delete()
}

class FileManagerService: FileManagerable {

    private struct Constants {
        static let fileName = "Archive"
        static let extensionName = "zip"
    }

    let fileManager: FileManager
    let documentDirectory: URL?

    init() {
        self.fileManager = FileManager.default
        do {
            documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        } catch {
            print("Error to create documentDirectory")
            documentDirectory = nil
        }
    }

    func write(record: Data) {
        if documentDirectory != nil {
            let fileURL = documentDirectory!.appendingPathComponent(Constants.fileName).appendingPathExtension(Constants.extensionName)
            print("File path: \(fileURL.path)")
            do {
                try record.write(to: fileURL)
                print("File saved successfuly")
            } catch {
                print("File wasn't saved")
            }
        }
    }

    func read(from name: String) -> URL? {
        if documentDirectory != nil {
            let fileURL = URL(fileURLWithPath: name, relativeTo: documentDirectory)
            return fileURL
        } else {
            return nil
        }
    }

    func delete() {
        if let pathForRecord = documentDirectory?.appendingPathComponent(Constants.fileName).appendingPathExtension(Constants.extensionName) {
            do {
                try fileManager.removeItem(at: pathForRecord)
                print("Record deleted successfuly")
            } catch {
                print("Error to delete file in Record")
            }
        }

        if let pathForUnZipedRecord = documentDirectory?.appendingPathComponent(Constants.fileName) {
            do {
                try fileManager.removeItem(at: pathForUnZipedRecord)
                print("UnZipedRecord deleted successfuly")
            } catch {
                print("Error to delete file in Record")
            }
        }
    }
}
