//
//  BetRequestTableViewCell.swift
//  bet
//
//  Created by Apple on 7/25/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit

class BetRequestTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var requestLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
