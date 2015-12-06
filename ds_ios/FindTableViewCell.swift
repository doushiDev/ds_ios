//
//  FindTableViewCell.swift
//  ds-ios
//
//  Created by Songlijun on 15/10/21.
//  Copyright © 2015年 Songlijun. All rights reserved.
//

import UIKit

class FindTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
 
    @IBOutlet weak var cellImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
