//
//  ProfileTableViewController.swift
//  Alpha
//
//  Created by Max Yendall on 16/05/2016.
//  Copyright © 2016 RMIT. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {

    // Singleton fetches
    let db = LocalDatabaseSingleton.sharedInstance;

    // Arrays for reference. Used for the table view
    var music   = [MusicNode]();
    var quotes  = [apiQuote]();
    var history = [ResponseData]();
    
    // Identifier for the type of generation
    var identifier : String = "";
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = identifier;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // Fetch the quotes, music, meditation and settings
        let count : Int;
        music       = db.getUserMusic();
        quotes      = db.getUserQuotes();
        history     = db.getUserResponses();
        
        // Return the count depending on the segue identifier
        switch(identifier)
        {
            case "Quotes":
                count = quotes.count;
            case "Music":
                count = music.count;
            case "History":
                count = history.count;
            default:
                count = 0;
        }
        
        return count;
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LabelCell", forIndexPath: indexPath);
        
        // Change the table view based on the identifier
        switch(identifier)
        {
            case "Quotes":
                cell.textLabel?.text = quotes[indexPath.row].category;
                cell.detailTextLabel?.text = quotes[indexPath.row].author;
            case "Music":
                cell.textLabel?.text = music[indexPath.row].prefix;
                cell.detailTextLabel?.text = music[indexPath.row].title;
            case "History":
                cell.textLabel?.text = history[indexPath.row].date;
                cell.detailTextLabel?.text = history[indexPath.row].feeling;
            default:
                cell.textLabel?.text = "Undefined";
        }
        
        return cell
    }
    
    // Title of the header is based on the identifier. I have chosen a simple selection:
    // 1) Favourites if module based
    // 2) Settings if settings based
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        var sectionHeader = "";
        // Change the table view based on the identifier
        switch(identifier)
        {
            case "Quotes":
                sectionHeader = "Favourites";
            case "Music":
                sectionHeader = "Favourites";
            case "History":
                sectionHeader = "Your History"
            default:
                sectionHeader = "Options";
        }
        return sectionHeader;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)
    {
        // Define static selector array (not fueled by a data source)
        var image : String = "";
        var firstLabel : String = "";
        var secondLabel : String = "";
        var titleLabel : String = "";
        // Set the destination seque to a tableViewController
        
        let indexPath = self.tableView.indexPathForSelectedRow!
        switch(identifier)
        {
            case "Quotes":
                image = "quotesIco";
                firstLabel = quotes[indexPath.row].quote;
                titleLabel = "Quotation:";
            case "Music":
                image = "musicIco";
                firstLabel = "Title: " + music[indexPath.row].title;
                titleLabel = "Music Title:";
            case "History":
                image = "emotionIco";
                titleLabel = "Emotion Response: ";
                firstLabel = "Emotion: " + history[indexPath.row].feeling;
                secondLabel = "What you were doing: " + history[indexPath.row].response;
            default:
                image = "emotionIco";
        }

        // Set the identifier to the selector title
        let detailsVC = segue.destinationViewController as! ProfileDetailViewController;
        detailsVC.headerImageName = image;
        detailsVC._title        = titleLabel;
        detailsVC.first         = firstLabel;
        detailsVC.second        = secondLabel;
    }
}
