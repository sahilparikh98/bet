//
//  DisplayBetRequestViewController.swift
//  bet
//
//  Created by Apple on 7/26/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit

class DisplayBetRequestViewController: UIViewController {
    @IBOutlet weak var fromUser: UILabel!
    @IBOutlet weak var betDescription: UILabel!
    @IBOutlet weak var betStakes: UILabel!

    var bet: Bet?
    override func viewDidLoad() {
        super.viewDidLoad()

        if let bet = bet
        {
            self.fromUser.text = bet.creatingUser!.username!
            self.betDescription.text = bet.betDescription!
            self.betStakes.text = bet.stakes!
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
