//
//  ThirdScreenViewController.swift
//  testTask
//
//  Created by Valerii Petrychenko on 3/27/19.
//  Copyright © 2019 Valerii Petrychenko. All rights reserved.
//

import UIKit
import Zip

class ThirdScreenViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    private struct Constants {
        static let CollectionViewCellName = "CollectionViewCell"
        static let objNameForUnZip = "Archive.zip"
    }

    @IBOutlet weak var inputURLTextField: UITextField!
    @IBOutlet weak var mainCollectionView: UICollectionView!

    private var viewForActivityIndicator: UIView!

    private var imagesArray = [UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }

    private func configure() {
        // mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        self.hideKeyboardWhenTappedAround()
    }

    @IBAction func findAction(_ sender: UIButton) {

        guard let urlString = inputURLTextField.text,
            let url: URL = URL(string: urlString)
            else { self.showAlert(title: "Error", message: "Wrong url"); return }

        viewForActivityIndicator = startLoader()
        imagesArray.removeAll()

        ZipRequestService().getZipFromURL(url: url) { (data, error) in
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
            } else if let data = data {
                let fm = FileManagerService()
                fm.delete()
                fm.write(record: data)
                if let zipUrl = fm.read(from: Constants.objNameForUnZip) {
                    do {
                        let unzipDirectory = try Zip.quickUnzipFile(zipUrl) // Unzip
                        let enumerator: FileManager.DirectoryEnumerator = fm.fileManager.enumerator(atPath: unzipDirectory.path)!
                        while let element = enumerator.nextObject() as? String {
                            if element.hasSuffix(".png") || element.hasSuffix(".jpg") ||
                               element.hasSuffix(".PNG") || element.hasSuffix(".JPG") {
                                if let image = UIImage(contentsOfFile: unzipDirectory.path + "/" + element) {
                                    self.imagesArray.append(image)
                                }
                            }
                        }
                    }
                    catch {
                        //print("Something went wrong")
                        self.showAlert(title: "Error", message: "Try to double check your link or it's not zip archive")
                    }
                }
            }
            DispatchQueue.main.async {
                self.mainCollectionView.reloadData()
                self.stopLoader(viewForRemove: self.viewForActivityIndicator)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.CollectionViewCellName, for: indexPath) as! CollectionViewCell
        cell.configure(image: imagesArray[indexPath.row])
        return cell
    }

}
