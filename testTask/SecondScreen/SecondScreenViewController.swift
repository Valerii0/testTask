//
//  SecondScreenViewController.swift
//  testTask
//
//  Created by Valerii Petrychenko on 3/27/19.
//  Copyright © 2019 Valerii Petrychenko. All rights reserved.
//

import UIKit
import CTPanoramaView

class SecondScreenViewController: UIViewController {

    @IBOutlet weak var panoramView: CTPanoramaView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpImage()
    }

    private func setUpImage() {
        if let image = UIImage(named: "spherical") {
            panoramView.image = image
            panoramView.controlMethod = .motion
        }
    }
}
