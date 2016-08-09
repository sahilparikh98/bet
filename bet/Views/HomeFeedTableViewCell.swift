//
//  HomeFeedTableViewCell.swift
//  bet
//
//  Created by Apple on 8/6/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit

class HomeFeedTableViewCell: UITableViewCell {

    @IBOutlet weak var creatingUserLabel: UILabel!
    @IBOutlet weak var creatingUserProfilePic: UIImageView!
    @IBOutlet weak var receivingUserProfilePic: UIImageView!
    @IBOutlet weak var receivingUserLabel: UILabel!
    @IBOutlet weak var viewButton: UIButton!
    @IBOutlet weak var cardView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        cardSetup()
        imageSetup()
    }
    
    func cardSetup()
    {
        self.cardView.layer.masksToBounds = false
        self.cardView.layer.cornerRadius = 1
        self.cardView.layer.shadowOffset = CGSizeMake(-0.2, 0.2)
        //%%% this shadow will hang slightly down and to the right
        self.cardView.layer.shadowRadius = 1
        //%%% I prefer thinner, subtler shadows, but you can play with this
        self.cardView.layer.shadowOpacity = 0.2
        //%%% same thing with this, subtle is better for me
        //%%% This is a little hard to explain, but basically, it lowers the performance required to build shadows.  If you don't use this, it will lag
        let path: UIBezierPath = UIBezierPath(rect: self.cardView.bounds)
        self.cardView.layer.shadowPath = path.CGPath
        self.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
    
    }
    
    func imageSetup()
    {
        self.creatingUserProfilePic.clipsToBounds = true
        self.creatingUserProfilePic.contentMode = .ScaleAspectFit
        self.creatingUserProfilePic.backgroundColor = UIColor.whiteColor()
        self.receivingUserProfilePic.clipsToBounds = true
        self.receivingUserProfilePic.contentMode = .ScaleAspectFit
        self.receivingUserProfilePic.backgroundColor = UIColor.whiteColor()
    }
    

}
