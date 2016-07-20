//
//  HomeController.swift
//  Alpha
//
//  Created by Max Yendall on 30/03/2016.
//  Copyright © 2016 RMIT. All rights reserved.
//

import UIKit

class HomeController: UIViewController {
    
    // Database reference
    var local_database = LocalDatabaseSingleton.sharedInstance;
    var firebase_model = FirebaseController();
    // Model Reference
    var model = ModelData.sharedInstance;
    // User reference
    var uref = 0;
    
    // Enumeration to represent a feeling
    enum Feeling : Int
    {
        case sad=1,neutral,happy,unselected;
    }
    
    // IBOutlet declarations
    @IBOutlet weak var happyImage: UIImageView!
    @IBOutlet weak var neutralImage: UIImageView!
    @IBOutlet weak var sadImage: UIImageView!
    
    @IBOutlet weak var feelingButton: UIButton!
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
    
    @IBAction func responseReturn(sender: UIButton)
    {
        // Hide all irrelevant fields until next push notification
        firstQuestionLabel.hidden   = false;
        secondQuestionLabel.hidden  = false;
        responseField.hidden        = false;
        happyButton.hidden          = false;
        sadButton.hidden            = false;
        neutralButton.hidden        = false;
        happyImage.hidden           = false;
        neutralImage.hidden         = false;
        sadImage.hidden             = false;
        submitButton.hidden         = false;
        
        // Disable all UI fields until next notification
        responseField.enabled       = true;
        happyButton.enabled         = true;
        neutralButton.enabled       = true;
        sadButton.enabled           = true;
        submitButton.enabled        = true;
        
        
        // Display message to the user
        thankYouMessage.text = "Thank you for your response!\nWhen you're ready, record another response ";
        thankYouMessage.hidden      = true;
        feelingButton.hidden        = true;
        feelingButton.enabled       = false;
        neutralImage.image = UIImage(named: "Neutral_Unselected");
        happyImage.image = UIImage(named: "Happy_Unselected");
        sadImage.image = UIImage(named: "Sad_Unselected");
        responseField.text = "";
        
    }
    // Function: Get current feeling as string for database insertion
    // @params: feeling : Feeling
    // @return: feeling as String
    func getFeelingAsString(feeling : Feeling)->String
    {
        switch(feeling)
        {
            case .happy:
                return "Happy";
            case .neutral:
                return "Neutral";
            case .sad:
                return "Sad";
            default:
                return "Undefined";
        }
    }
    @IBAction func submitTextChanged(sender: UITextField)
    {
        submitButton.enabled = true;
        submitButton.alpha = 1.0;
    }
    // Function: Send information to database for notification of emotion history
    // @params: UIButton : Touch Down
    // @return: void
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
        
        // Disable all UI fields until next notification
        responseField.enabled       = false;
        happyButton.enabled         = false;
        neutralButton.enabled       = false;
        sadButton.enabled           = false;
        submitButton.enabled        = false;
    
        let date = NSDate();
        let calendar = NSCalendar.currentCalendar();
        let _date = calendar.components([.Day, .Month, .Year],fromDate: date);
        let time = calendar.components([.Hour, .Minute, .Second], fromDate: date);
        
        let year = String(_date.year);
        let month = String(_date.month);
        let day = String(_date.day);
        let hour = String(time.hour);
        let minute = String(time.minute);
        let yearString = year + "-" + month + "-" + day;
        let timeString = hour + ":" + minute;
        
        let dateString = yearString + "-" + timeString;
        
        let new_response = ResponseData(
            date: dateString,
            response: responseField.text!,
            feeling: getFeelingAsString(feeling))
        
        firebase_model.pushUserResponse(new_response)
        {
            success in
            // Display message to the user
            self.thankYouMessage.text = "Thank you for your response!\nWhen you're ready, record another response\n\nRemember to review your responses in your profile :)";
            self.thankYouMessage.hidden      = false;
            self.feelingButton.hidden        = false;
            self.feelingButton.enabled       = true;
        }
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
        submitButton.enabled = false;
        submitButton.alpha = 0.5;
        feelingButton.enabled = false;
        feelingButton.hidden = true;
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}