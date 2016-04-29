//
//  User.swift
//  Alpha
//
//  Created by Max Yendall on 31/03/2016.
//  Copyright © 2016 RMIT. All rights reserved.
//

import Foundation

class User
{
    // Property definition
    var username : String;
    var passwordKey : String;
    var firstName : String;
    var lastName : String;
    
    // Initialiser for all recieved properties
    init(username: String, passwordKey: String, firstName: String, lastName: String)
    {
        self.username = username;
        self.passwordKey = passwordKey.encryptXOR(28);
        self.firstName = firstName;
        self.lastName = lastName;
    }
    
    // Password retrieval can be decrypted by using 0 as the key
    
}

// Custom error type for User model
enum UserError : ErrorType
{
    case invalidUsername(username: String);
    case invalidFirstName(firstname: String);
    case invalidLastName(lastname: String);
}