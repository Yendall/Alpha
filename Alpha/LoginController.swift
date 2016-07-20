//
//  LoginController.swift
//  Alpha
//
//  Created by Max Yendall on 31/03/2016.
//  Copyright © 2016 RMIT. All rights reserved.
//

import UIKit
import Firebase
class LoginController: UIViewController {
    
    // Firebase and Memory Model Object reference
    var firebase_ref = FirebaseController();
    var model_ref = ModelData.sharedInstance;
    
    @IBOutlet weak var loginButton: UIButton!;
    @IBOutlet weak var registerHomebutton: UIButton!;
    @IBOutlet weak var registerButton: UIButton!;
    @IBOutlet weak var loginUsernameField: UITextField!;
    @IBOutlet weak var loginPasswordField: UITextField!;
    @IBOutlet weak var registerUsernameField: UITextField!;
    @IBOutlet weak var registerPasswordField: UITextField!;
    @IBOutlet weak var registerFirstNameField: UITextField!;
    @IBOutlet weak var registerLastNameField: UITextField!;
    @IBOutlet weak var registerRepeatPasswordField: UITextField!;
    
    // Clear all textfields. Usually called when there is an error in validation.
    // Can be used a utility for debugging if need be
    // @return: void
    func clearRegisterTextFields()
    {
        registerUsernameField.text = "";
        registerFirstNameField.text = "";
        registerLastNameField.text = "";
        registerPasswordField.text = "";
        registerRepeatPasswordField.text = "";
        
        registerUsernameField.becomeFirstResponder();
    }
    
    // Clear all textfields. Usually called when there is an error in validation.
    // Can be used a utility for debugging if need be
    // @return: void
    func clearLoginTextFields()
    {
        loginUsernameField.text = "";
        loginPasswordField.text = "";
        
        loginUsernameField.becomeFirstResponder();
    }
    
    // Display an error message to the user with customised title and message
    // @params: title : String, message : String
    // @return: Error message pane on UX
    func displayErrorMessage(title : String, message : String)
    {
        // Create an alert with the passed values
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert);
        // Create the button title. We will keep this the same as it works with all issues
        alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: nil));
        // Display the error message
        self.presentViewController(alert, animated: true, completion: nil);
    }
    
    // Action function to initiate login for a valid user. Directs the flow of the application
    // to the Tab Bar Controller
    // @params: UIButton : Touch Down
    // @return: void
    @IBAction func login(sender: UIButton)
    {
        // Email and Password variables
        let email : String = loginUsernameField.text!;
        let password : String = loginPasswordField.text!;
        
        // Disable buttons while authenticating
        loginButton.enabled = false;
        registerHomebutton.enabled = false;
        loginButton.alpha = 0.5;
        registerHomebutton.alpha = 0.5;
        
        loginUsernameField.enabled = false;
        loginPasswordField.enabled = false;
        
        // Authenticate users with Firebase
        firebase_ref.ref.authUser(email, password: password, withCompletionBlock:
        {
            error, authData in
            if(error != nil)
            {
                
                // A message to let the user know their details were incorrect
                let message = "Your details are incorrect! :(\n please try again";
                // Send an alert letting the user know they have entered the wrong details
                self.displayErrorMessage("Incorrect Credentials", message: message);
                // Enable buttons and revert alpha transparenchy
                self.loginButton.enabled = true;
                self.registerHomebutton.enabled = true;
                self.loginButton.alpha = 1.0;
                self.registerHomebutton.alpha = 1.0;
                // Clear the text fields
                self.clearLoginTextFields();
                // Enable the text fields
                self.loginUsernameField.enabled = true;
                self.loginPasswordField.enabled = true;
            }
            else
            {
                // Initiate segue based on the identifying link between the login page
                // and the Tab Bar Controller
                self.firebase_ref.firebase_fetch(authData.uid);
                self.performSegueWithIdentifier("loginSegue", sender: nil)
            }
        })
    }
    
    // Transition to the register page
    // @params: UIButton : Touch Down
    // @return: void
    @IBAction func register(sender: UIButton)
    {
        // Initiate segue based on the identifying link between the login page
        // and the Register page
        // This will not need to pass anything at this stage
        self.performSegueWithIdentifier("registerSegue", sender: nil)
    }
    
    // Transition to the login page
    // @params: UIButton : Touch Down
    // @return: void
    @IBAction func registerReturn(sender: UIButton)
    {
        // Constants from user input in registration fields
        let email : String = registerUsernameField.text!;
        let firstname : String = registerFirstNameField.text!;
        let lastname : String = registerLastNameField.text!;
        let password : String = registerPasswordField.text!;
        let repeatPassword : String = registerRepeatPasswordField.text!;
        
        
        if(email.isEmpty)
        {
            // A message to let the user know their details were incorrect
            let message = "Email cannot be empty\n please try again";
            // Send an alert letting the user know they have entered the wrong details
            self.displayErrorMessage("Empty Email", message: message);
        }
        else if(password.isEmpty || repeatPassword.isEmpty)
        {
            // A message to let the user know their details were incorrect
            let message = "Empty password field detected\n please try again";
            // Send an alert letting the user know they have entered the wrong details
            self.displayErrorMessage("Empty Password", message: message);
        }
        else if(password != repeatPassword)
        {
            // A message to let the user know their details were incorrect
            let message = "Passwords do not match!\n please try again";
            // Send an alert letting the user know they have entered the wrong details
            self.displayErrorMessage("Password Mismatch", message: message);
        }
        else
        {
            
            // Disable button and fade
            self.registerButton.enabled = false;
            self.registerButton.alpha = 0.5;
            // Disable text fields
            registerUsernameField.enabled = false;
            registerFirstNameField.enabled = false;
            registerLastNameField.enabled = false;
            registerRepeatPasswordField.enabled = false;
            registerPasswordField.enabled = false;
            
            // Creation of the new user object, this will be inserted into Firebase
            firebase_ref.ref.createUser(email, password: password, withValueCompletionBlock:
                { error, result in
                    if error != nil
                    {
                        if let errorCode = FAuthenticationError(rawValue: error.code)
                        {
                            switch(errorCode)
                            {
                                case .EmailTaken:
                                    // A message indicating the email is already linked to an account
                                    let message = "Email is already taken!\n please try again";
                                    // Send an alert letting the user know they have entered the wrong details
                                    self.displayErrorMessage("Email Taken", message: message);
                                    // Re-enabled the register button to try again. Also, clear fields.
                                    self.registerButton.enabled = true;
                                    self.registerButton.alpha = 1.0;
                                    self.clearRegisterTextFields();
                                    // Enable the fields
                                    self.registerUsernameField.enabled = true;
                                    self.registerFirstNameField.enabled = true;
                                    self.registerLastNameField.enabled = true;
                                    self.registerRepeatPasswordField.enabled = true;
                                    self.registerPasswordField.enabled = true;
                                    
                                    break;
                                default:
                                    debugPrint("Invalid situation")
                            }
                        }
                    }
                    else
                    {
                        // Test UID
                        let uid = result["uid"] as? String
                        
                        let user_data =
                        [
                            "uid" : uid!,
                            "email" : email,
                            "firstname" : firstname,
                            "lastname" : lastname,
                        ];
                        
                        // Upload new user object
                        let usersRef = self.firebase_ref.ref.childByAppendingPath("Users");
                        // Create user data, quote data and music data
                        let user = [uid! : user_data];
                        // Set values in Firebase
                        usersRef.updateChildValues(user);
                        
                        self.performSegueWithIdentifier("loginReturnSegue", sender: nil)
                    }
            })
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}