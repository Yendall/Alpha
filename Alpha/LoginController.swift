//
//  LoginController.swift
//  Alpha
//
//  Created by Max Yendall on 31/03/2016.
//  Copyright © 2016 RMIT. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    @IBOutlet weak var loginUsernameField: UITextField!
    @IBOutlet weak var loginPasswordField: UITextField!
    @IBOutlet weak var registerUsernameField: UITextField!
    @IBOutlet weak var registerPasswordField: UITextField!
    @IBOutlet weak var registerRepeatPasswordField: UITextField!
    
    // Action function to initiate login for a valid user. Directs the flow of the application
    // to the Tab Bar Controller
    @IBAction func login(sender: UIButton)
    {
        let username : String = loginUsernameField.text!;
        let password : String = loginPasswordField.text!;
        let passwordEncrypted : String = password.encryptXOR(28);
        // let passwordDecrypted : String = password.encryptXOR(0);
        
        // Display authentication alert if the details don't match the dummy User object (this will be expanded in
        // Assignment 2)
        if(username == "maxyendall" && passwordEncrypted == "test".encryptXOR(28))
        {
            // Initiate segue based on the identifying link between the login page
            // and the Tab Bar Controller
            // This will eventually need to send a User Object to the Tab Bar Controller
            self.performSegueWithIdentifier("loginSegue", sender: nil)
            
        }
        else
        {
            // Send an alert letting the user know they have entered the wrong details
            let alert = UIAlertController(title: "Incorrect Credentials", message: "Your details are incorrect! :(\n please try again", preferredStyle: UIAlertControllerStyle.Alert);
            alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: nil));
            self.presentViewController(alert, animated: true, completion: nil);
        }
    }
    
    @IBAction func register(sender: UIButton)
    {
        // Initiate segue based on the identifying link between the login page
        // and the Register page
        // This will not need to pass anything at this stage
        self.performSegueWithIdentifier("registerSegue", sender: nil)
    
    }
    
    @IBAction func registerReturn(sender: UIButton)
    {
        // Constants from user input in registration fields
        let username : String = registerUsernameField.text!;
        let password : String = registerPasswordField.text!;
        let repeatPassword : String = registerRepeatPasswordField.text!;
        
        if(username.isEmpty)
        {
            // Send an alert letting the user know they have entered the wrong details
            let alert = UIAlertController(title: "Username Empty", message: "Username cannot be empty\n please try again", preferredStyle: UIAlertControllerStyle.Alert);
            alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: nil));
            self.presentViewController(alert, animated: true, completion: nil);
        }
        else if(password != repeatPassword)
        {
            // Send an alert letting the user know they have entered the wrong details
            let alert = UIAlertController(title: "Password Mismatch", message: "Passwords no not match!\n please try again", preferredStyle: UIAlertControllerStyle.Alert);
            alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: nil));
            self.presentViewController(alert, animated: true, completion: nil);
        }
        else
        {
            // Creation of the new user object, this will be inserted into a Database
            
            let newUser = User(username: username,passwordKey : password,firstName: "",lastName: "");
            
            debugPrint(newUser.username, newUser.lastName,newUser.passwordKey);
            
            self.performSegueWithIdentifier("loginReturnSegue", sender: nil)
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FirebaseController();

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}