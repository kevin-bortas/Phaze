//
//  CustomTableViewCell.swift
//  Phaze
//
//  Created by Kevin Cogan on 27/02/2022.
//  Copyright © 2022 UnKnown. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var celllView: UIView!
    @IBOutlet weak var mealImage: UIImageView!
    @IBOutlet weak var mealLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
