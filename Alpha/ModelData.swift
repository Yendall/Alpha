//
//  ModelData.swift
//  Alpha
//
//  Created by Max Yendall on 2/04/2016.
//  Copyright © 2016 RMIT. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import SwiftyJSON

public class ModelData
{
    // Singleton use
    static let sharedInstance = ModelData();
    
    // Empty constructor
    private init(){}
    
    // Default data models for each section in memory
    var meditationData  = [MeditationData]();
    var alphaData       = [MusicDataNode]();
    var thetaData       = [MusicDataNode]();
    var imageData       = [ImageData]();
    var userData        = [User]();
}

// AVState data class
class AVState
{
    var prefix      : String;
    var state       : String;
    
    init(prefix: String, state: String)
    {
        self.prefix = prefix;
        self.state = state;
    }
}

// Response data class
class ResponseData
{
    var date        : String;
    var response    : String;
    var feeling     : String;
    
    init (date: String, response: String, feeling: String)
    {
        self.date = date;
        self.response = response;
        self.feeling = feeling;
    }
}

// User Data Class
class User
{
    var uid         :   String;
    var email       :   String;
    var firstname   :   String;
    var lastname    :   String;
    var music       :   [MusicDataNode];
    
    init(uid: String, email: String, firstname: String, lastname: String)
    {
        self.uid = uid;
        self.email = email;
        self.firstname = firstname;
        self.lastname = lastname;
        self.music = [MusicDataNode]();
    }
    
}
// MusicDataNode class with a prefix for usage with Firebase
class MusicDataNode
{
    var musicID     : String;
    var prefix      : String;
    var musicURL    : String;
    var imageURL    : String;
    var title       : String;
    
    init(musicID: String, prefix: String, musicURL: String,imageURL: String, title: String)
    {
        self.musicID = musicID;
        self.prefix = prefix;
        self.musicURL = musicURL;
        self.imageURL = imageURL;
        self.title = title;
    }
}

// MusicNode class with a prefix determining its type
class MusicNode
{
    var musicID     : String;
    var prefix      : String;
    var musicURL    : String;
    var title       : String;
    var liked       : Bool;
    
    init(musicID: String, prefix: String, musicURL: String, title: String,liked: Bool)
    {
        self.musicID = musicID;
        self.prefix = prefix;
        self.musicURL = musicURL;
        self.title = title;
        self.liked = liked;
    }
}

// Meditation Data Class (this will be modified later)
class MeditationData
{
    var index       :   String;
    var image       :   String;
    var dataTitle   :   String;
    var dataBody    :   String;
    
    init(index: String, image: String, dataTitle: String, dataBody: String)
    {
        self.index = index;
        self.image = image;
        self.dataTitle = dataTitle;
        self.dataBody = dataBody;
    }
    
}

// Image Data Class
class ImageData
{
    var index       :   Int;
    var imageSRC    :   String;
    
    init(index: Int, imageSRC: String)
    {
        self.index = index;
        self.imageSRC = imageSRC;
    }
}

// Extension for CA Layer to define a borders colour on a button
extension CALayer
{
    var borderUIColor: UIColor {
        set {
            self.borderColor = newValue.CGColor
        }
        
        get {
            return UIColor(CGColor: self.borderColor!)
        }
    }
}

// String extension to add a String function to encrypt using a key.
extension String
{
    func encryptXOR(key: UInt8) -> String
    {
        return String(bytes: self.utf8.map{$0 ^ key}, encoding: NSUTF8StringEncoding) ?? ""
    }
}