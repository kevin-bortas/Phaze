//
//  CustomDinnerTableViewCell.swift
//  Phaze
//
//  Created by Kevin Cogan on 11/04/2022.
//  Copyright © 2022 UnKnown. All rights reserved.
//

import UIKit

class CustomDinnerTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var dinnerLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
