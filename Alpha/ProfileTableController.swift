//
//  ProfileTableController.swift
//  Alpha
//
//  Created by Max Yendall on 12/05/2016.
//  Copyright © 2016 RMIT. All rights reserved.
//

import Foundation
//
//  TarotCardTableViewController.swift
//  Tarot
//
//  Created by Rodney Cocker on 6/04/2016.
//  Copyright © 2016 RMIT. All rights reserved.
//

import Foundation
import UIKit

class ProfileTableController: UITableViewController
{
 
    // Model reference
    let model = ModelData.sharedInstance;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.sectionHeaderHeight = 70;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        self.performSegueWithIdentifier("profileSection", sender: tableView)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)
    {
        // Define static selector array (not fueled by a data source)
        let selector = ["Quotes","Music","History"];
        
        // Set the destination seque to a tableViewController
        let profileSectionController =
            segue.destinationViewController as! UITableViewController
        let indexPath = self.tableView.indexPathForSelectedRow!
        profileSectionController.title = selector[indexPath.row];
        
        // Set the identifier to the selector title
        let detailsVC = segue.destinationViewController as! ProfileTableViewController;
        detailsVC.identifier = selector[indexPath.row];
    }
}
