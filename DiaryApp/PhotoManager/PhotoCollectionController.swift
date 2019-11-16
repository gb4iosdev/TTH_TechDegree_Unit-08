//
//  PhotoCollectionController.swift
//  DiaryApp
//
//  Created by Gavin Butler on 13-11-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import UIKit
import CoreData

class PhotoCollectionController: UIViewController {
    
    var images: [UIImage]?
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoCollectionView.dataSource = self
    }
    
}

// MARK: - CollectionViewDataSource methods:

extension PhotoCollectionController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifier, for: indexPath) as! PhotoCell
        
        if let images = self.images {
            photoCell.photoImageView.image = images[indexPath.row]
        }
        
        return photoCell
    }
    
    
}
