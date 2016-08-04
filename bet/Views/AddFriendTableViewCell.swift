//
//  AddFriendTableViewCell.swift
//  bet
//
//  Created by Apple on 8/3/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import Parse

protocol AddFriendTableViewCellDelegate: class
{
    func cell(cell: AddFriendTableViewCell, didSelectAddUser: PFUser)
    func cell(cell: AddFriendTableViewCell, didSelectRemoveUser: PFUser)
}

class AddFriendTableViewCell: UITableViewCell
{
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    weak var delegate: AddFriendTableViewCellDelegate?
    var user: PFUser?
    {
        didSet
        {
            usernameLabel.text = user?.username
        }
    }
    
    var canAdd: Bool?
    {
        didSet
        {
            if let canAdd = canAdd
            {
                addButton.selected = !canAdd
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func addButtonPressed(sender: AnyObject) {
        if let canAdd = canAdd where canAdd == true
        {
            delegate?.cell(self, didSelectAddUser: user!)
            self.canAdd = false
        }
        else
        {
            delegate?.cell(self, didSelectRemoveUser: user!)
            self.canAdd = true
        }
    }
}
