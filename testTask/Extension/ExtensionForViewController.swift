//
//  ExtensionForViewController.swift
//  testTask
//
//  Created by Valerii Petrychenko on 3/28/19.
//  Copyright © 2019 Valerii Petrychenko. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    ///Custom Alert
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(alertAction)
        present(alert, animated: true)
    }


    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func startLoader() -> UIView {
        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        backgroundView.backgroundColor = .white
        let activityView = UIActivityIndicatorView(style: .gray)
        activityView.center = self.view.center
        activityView.startAnimating()
        backgroundView.addSubview(activityView)
        self.view.addSubview(backgroundView)
        return backgroundView
    }

    func stopLoader(viewForRemove: UIView) {
        DispatchQueue.main.async {
            viewForRemove.removeFromSuperview()
        }
    }
}
