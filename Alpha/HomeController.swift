//
//  HomeController.swift
//  Alpha
//
//  Created by Max Yendall on 30/03/2016.
//  Copyright © 2016 RMIT. All rights reserved.
//

import UIKit

class HomeController: UIViewController {
    
    // Enumeration to represent a feeling
    enum Feeling : Int
    {
        case sad=1,neutral,happy,unselected;
    }
    
    // IBOutlet declarations
    @IBOutlet weak var happyImage: UIImageView!
    @IBOutlet weak var neutralImage: UIImageView!
    @IBOutlet weak var sadImage: UIImageView!
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var firstQuestionLabel: UILabel!
    @IBOutlet weak var thankYouMessage: UILabel!
    @IBOutlet weak var secondQuestionLabel: UILabel!
    @IBOutlet weak var responseField: UITextField!
    @IBOutlet weak var happyButton: UIButton!
    @IBOutlet weak var neutralButton: UIButton!
    @IBOutlet weak var sadButton: UIButton!
    
    // feeling variable for tracking user input
    var feeling: Feeling = Feeling.unselected;
    
    // Function: Send information to database for notification of emotion history
    @IBAction func sendResponse(sender: UIButton)
    {
        // Hide all irrelevant fields until next push notification
        firstQuestionLabel.hidden   = true;
        secondQuestionLabel.hidden  = true;
        responseField.hidden        = true;
        happyButton.hidden          = true;
        sadButton.hidden            = true;
        neutralButton.hidden        = true;
        happyImage.hidden           = true;
        neutralImage.hidden         = true;
        sadImage.hidden             = true;
        submitButton.hidden         = true;
        
        // Disable all UI fields until next push notification
        responseField.enabled       = false;
        happyButton.enabled         = false;
        neutralButton.enabled       = false;
        sadButton.enabled           = false;
        submitButton.enabled        = false;
    
        
        // Display message to the user
        thankYouMessage.text        = "Thank you!\nWe will ask you again shortly";
        thankYouMessage.hidden      = false;
        
        
    }
    // Function: A selector for when the user presses the sad image, this will activate the feeling variable
    // and pass it to the database. Also an un-selector.
    @IBAction func sadSelection(sender: UIButton)
    {
        if(feeling == .sad)
        {
            feeling = Feeling.unselected;
            sadImage.image = UIImage(named: "Sad_Unselected");
        }
        else
        {
            sadImage.image = UIImage(named: "Sad");
            neutralImage.image = UIImage(named: "Neutral_Unselected");
            happyImage.image = UIImage(named: "Happy_Unselected");
        
            feeling = Feeling.sad;
        }
    }
    
    // Function: A selector for when the user presses the neutral image, this will activate the feeling
    // variable and pass it to the database. Also an un-selector.
    @IBAction func neutralSelection(sender: UIButton)
    {
        if(feeling == .neutral)
        {
            feeling = Feeling.unselected;
            neutralImage.image = UIImage(named: "Neutral_Unselected");
        }
        else
        {
            neutralImage.image = UIImage(named: "Neutral");
            sadImage.image = UIImage(named: "Sad_Unselected");
            happyImage.image = UIImage(named: "Happy_Unselected");
            
            feeling = Feeling.neutral;
        }
    }
    
    // Function: A selector for when the user presses the happy image, this will activate the feeling
    // variable and pass it to the database. Also an un-selector.
    @IBAction func happySelection(sender: UIButton)
    {
        if(feeling == .happy)
        {
            feeling = Feeling.unselected;
            happyImage.image = UIImage(named: "Happy_Unselected");
        }
        else
        {
            happyImage.image = UIImage(named: "Happy");
            neutralImage.image = UIImage(named: "Neutral_Unselected");
            sadImage.image = UIImage(named: "Sad_Unselected");
        
            feeling = Feeling.happy;
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}