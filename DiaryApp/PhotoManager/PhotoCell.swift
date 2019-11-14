//
//  PhotoCell.swift
//  DiaryApp
//
//  Created by Gavin Butler on 13-11-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: PhotoCell.self)
    
    @IBOutlet weak var photoImageView: UIImageView!

}
