//
//  VideoTableViewCell.swift
//  ds-ios
//
//  Created by Songlijun on 15/10/5.
//  Copyright © 2015年 Songlijun. All rights reserved.
//

import UIKit

class VideoTableViewCell: UITableViewCell {

    @IBOutlet weak var picImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func videlInit(picImageView: UIImageView!,titleLabel: UILabel!,timeLabel: UILabel!){
        
        self.picImageView = picImageView
        self.timeLabel = timeLabel
        self.titleLabel = titleLabel
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
