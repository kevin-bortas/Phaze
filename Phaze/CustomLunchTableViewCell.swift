//
//  CustomLunchTableViewCell.swift
//  Phaze
//
//  Created by Kevin Cogan on 11/04/2022.
//  Copyright © 2022 UnKnown. All rights reserved.
//

import UIKit

class CustomLunchTableViewCell: UITableViewCell {

    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var lunchLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
