//
//  CollectionViewCell.swift
//  testTask
//
//  Created by Valerii Petrychenko on 3/27/19.
//  Copyright © 2019 Valerii Petrychenko. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var loadImage: UIImageView!

    func configure(image: UIImage) {
        loadImage.image = image
        loadImage.contentMode = .scaleAspectFit
    }
}
