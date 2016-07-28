//
//  MyBetsViewController.swift
//  bet
//
//  Created by Apple on 7/21/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit

class MyBetsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var myBets: [Bet] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier
        {
            if identifier == "createBet"
            {
                print("creating bet")
            }
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}

extension MyBetsViewController: UITableViewDataSource
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myBets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BetCell")!
        cell.textLabel!.text = "Bet"
        return cell
    }
}
