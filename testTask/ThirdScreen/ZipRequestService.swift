//
//  ZipRequestService.swift
//  testTask
//
//  Created by Valerii Petrychenko on 3/27/19.
//  Copyright © 2019 Valerii Petrychenko. All rights reserved.
//

import Foundation

class ZipRequestService {

    func getZipFromURL(url: URL, callBack: @escaping (_ data: Data?, _ error: Error?) -> Void) {

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let responseError = error {
                print(responseError.localizedDescription)
                callBack(nil, error)
            } else if let responseData = data {
                callBack(responseData, nil)
            }
        }
        task.resume()
    }
}
