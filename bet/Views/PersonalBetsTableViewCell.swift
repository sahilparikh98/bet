//
//  PersonalBetsTableViewCell.swift
//  bet
//
//  Created by Apple on 7/29/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit

class PersonalBetsTableViewCell: UITableViewCell {
    @IBOutlet weak var usersInvolved: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var betDescription: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
