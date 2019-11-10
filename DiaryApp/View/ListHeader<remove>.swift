//
//  ListHeader.swift
//  DiaryApp
//
//  Created by Gavin Butler on 09-11-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import UIKit

class ListHeader {
    
    static func view(withWidth width: CGFloat) -> UIView {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 44))
        view.backgroundColor = UIColor.white
        view.heightAnchor.constraint(equalToConstant: 44.0)
        
        let dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.numberOfLines = 0
        dateLabel.text = "This is the date"
        view.addSubview(dateLabel)
        
        let subscriptLabel = UILabel()
        subscriptLabel.translatesAutoresizingMaskIntoConstraints = false
        subscriptLabel.numberOfLines = 1
        subscriptLabel.font = subscriptLabel.font.withSize(12)
        subscriptLabel.text = "Record your thoughts for today!"
        view.addSubview(subscriptLabel)
        
        NSLayoutConstraint.activate([
            subscriptLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8)
//            dateLabel.leadingAnchor.constraint(equalTo: logoView.trailingAnchor, constant: 8),
//            dateLabel.trailingAnchor.constraint(equalTo: attributionView.trailingAnchor, constant: 0)
            ])
        
        return view
    }
    
}
