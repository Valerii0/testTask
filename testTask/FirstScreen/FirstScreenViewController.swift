//
//  FirstScreenViewController.swift
//  testTask
//
//  Created by Valerii Petrychenko on 3/27/19.
//  Copyright © 2019 Valerii Petrychenko. All rights reserved.
//

import UIKit
import SQLite3

class FirstScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private struct Constants {
        static let CellName = "Cell"
    }

    @IBOutlet weak var inputForAddActionTextField: UITextField!
    @IBOutlet weak var inputForSortTextField: UITextField!

    @IBOutlet weak var mainTableView: UITableView!

    private var wordsArray = [Word]()
    private var filteredWordsArray = [Word]()
    private var isFiltered = false

    var sqlFileManagerService = SQLFileManagerService()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        configure()
        updateTable()
    }

    private func setUpUI() {
        mainTableView.tableFooterView = UIView()
    }

    private func configure() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        self.hideKeyboardWhenTappedAround()
        inputForSortTextField.addTarget(self, action : #selector(textFieldDidChange), for : .editingChanged)
    }

    @objc func textFieldDidChange() {
        guard let inputText = inputForSortTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        if !inputText.isEmpty {
            isFiltered = true
            updateFilteredTable(with: inputText)
        } else {
            isFiltered = false
            updateTable()
        }
    }

    private func updateTable() {
        wordsArray = sqlFileManagerService.read()
        self.mainTableView.reloadData()
    }

    private func updateFilteredTable(with inputText: String) {
        filteredWordsArray = sqlFileManagerService.read().filter( { $0.name.lowercased().hasPrefix(inputText.lowercased()) })
        self.mainTableView.reloadData()
    }

    @IBAction func AddTextToTableAction(_ sender: UIButton) {
        guard let inputText = inputForAddActionTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        inputForAddActionTextField.text = ""
        if !inputText.isEmpty {
            sqlFileManagerService.write(with: inputText)
            updateTable()
        } else { self.showAlert(title: "Error", message: "Print something!") }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltered {
            return filteredWordsArray.count
        } else {
            return wordsArray.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mainTableView.dequeueReusableCell(withIdentifier: Constants.CellName, for: indexPath)
        cell.textLabel?.text = isFiltered ? filteredWordsArray[indexPath.row].name : wordsArray[indexPath.row].name
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if isFiltered {
                sqlFileManagerService.delete(with: filteredWordsArray[indexPath.row].id)
                self.filteredWordsArray.remove(at: indexPath.row)
            } else {
                sqlFileManagerService.delete(with: wordsArray[indexPath.row].id)
                self.wordsArray.remove(at: indexPath.row)
            }
            mainTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

