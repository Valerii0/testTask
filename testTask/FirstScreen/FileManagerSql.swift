//
//  FileManagerSql.swift
//  testTask
//
//  Created by Valerii Petrychenko on 3/28/19.
//  Copyright © 2019 Valerii Petrychenko. All rights reserved.
//

import Foundation
import SQLite3

protocol SQLFileManagerable {
    func write(with inputText: String)
    func read() -> [Word]
    func delete(with id: Int)
}

class SQLFileManagerService: SQLFileManagerable {

    private struct Constants {
        static let dbName = "StringsDatabase.sqlite"
        static let dbTable = "StringsTable"
        static let dbWord = "word"
    }

    let fileManager: FileManager
    let fileURL: URL?
    var db: OpaquePointer?

    init() {
        self.fileManager = FileManager.default
        do {
            fileURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent(Constants.dbName)

            if sqlite3_open(fileURL!.path, &db) != SQLITE_OK {
                print("error opening database")
            }

            if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS \(Constants.dbTable) (id INTEGER PRIMARY KEY AUTOINCREMENT, \(Constants.dbWord) TEXT)", nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error creating table: \(errmsg)")
            }
        } catch {
            print("Error to create documentDirectory")
            fileURL = nil
        }
    }

    func write(with inputText: String) {
        //creating a statement
        var stmt: OpaquePointer?

        //the insert query
        let queryString = "INSERT INTO \(Constants.dbTable) (\(Constants.dbWord)) VALUES (?)"

        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }

        //binding the parameters
        if sqlite3_bind_text(stmt, 1, inputText, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }

        //executing the query to insert values
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting word: \(errmsg)")
            return
        }
    }

    func read() -> [Word] {
        var returnWordsArray = [Word]()
        //this is our select query
        let queryString = "SELECT * FROM \(Constants.dbTable)"

        //statement pointer
        var stmt:OpaquePointer?

        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return returnWordsArray
        }

        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW) {
            let id = sqlite3_column_int(stmt, 0)
            let name = String(cString: sqlite3_column_text(stmt, 1))

            //adding values to list
            returnWordsArray.append(Word(id: Int(id), name: String(describing: name)))
        }

        return returnWordsArray
    }

    func delete(with id: Int) {
        var deleteStatement: OpaquePointer? = nil
        let deleteStatementStirng = "DELETE FROM \(Constants.dbTable) WHERE Id = \(id);"
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }

        sqlite3_finalize(deleteStatement)
    }
}
