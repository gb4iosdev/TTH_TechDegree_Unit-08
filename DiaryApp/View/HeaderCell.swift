//
//  HeaderCell.swift
//  DiaryApp
//
//  Created by Gavin Butler on 09-11-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import UIKit

class HeaderCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
