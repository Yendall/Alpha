//
//  FirebaseController.swift
//  Alpha
//
//  Created by Max Yendall on 29/04/2016.
//  Copyright © 2016 RMIT. All rights reserved.
//

import UIKit
import Firebase
import SQLite
import SwiftyJSON

class FirebaseController
{
    // Singlton database reference
    let db = LocalDatabaseSingleton.sharedInstance;
    let model = ModelData.sharedInstance;
    // Firebase references
    let ref_path = "https://max-alpha.firebaseio.com/";
    let ref = Firebase(url:"https://max-alpha.firebaseio.com/");
    
    
    // Empty constructor
    init(){}
    
    // Fetch data from firebase storage
    // @return: firebase data in the form of an array
    func firebase_fetch(uid : String = "")
    {
     
        // Retrieve user data and check for thread completion.
        // Once the thread is completed, move the data to memory
        retrieveUserData(uid)
        {
            success in
            self.db.userToMemory();
            
            // Retrieve meditation data and check for thread completion.
            // Once the thread is completed, move the data to memory
            self.retrieveMeditationData()
            {
                    success in
                    self.db.meditationToMemory();
            }
        }
    }
    
    func updateUserQuotes(uid : String)
    {
        // Fetch users stored quotes
        self.ref.childByAppendingPath("UserQuotes/"+uid).observeSingleEventOfType(
            FEventType.Value, withBlock: { (snapshot) -> Void in
                
                // Check existance in child nodes
                for quoteChild in snapshot.children
                {
                    let quoteSnapshot = snapshot.childSnapshotForPath(quoteChild.key);
                    let id = quoteChild.key;
                    let author = quoteSnapshot.value["author"] as! String;
                    let quote = quoteSnapshot.value["quote"] as! String;
                    let liked = quoteSnapshot.value["liked"] as! String;
                    let category = quoteSnapshot.value["category"] as! String;
                    var liked_bool = false;
                    
                    if(liked == "true")
                    {
                        liked_bool = true;
                    }
                    
                    // Create quote object
                    let quote_obj = apiQuote(id: id, quote: quote, author: author, liked: liked_bool,category: category);
                    
                    // Insert into database
                    self.db.insertUserQuoteData(quote_obj);
                }
        })
    }
    
    // Delete a linked music file in Firebase and update the database accordingly
    // @params: musicID : String
    // @return: void
    func deleteUserMusic(musicID : String, prefix: String, completionHandler: (Bool) -> ())
    {
        // Fetch user information from database
        let user = db.getUserInformation();
        // Begin deleting from the child node affliated with the UID and quoteID
        let userMusicChildren = ref.childByAppendingPath("UserMusic/"+user.uid+"/"+prefix+"/"+musicID);
        
        userMusicChildren.removeValue();
        db.deleteMusic(musicID,_prefix: prefix);
        completionHandler(true);
    }
    
    // Delete a linked quote in Firebase and update the database accordingly
    // @params: quoteID : String
    // @return: void
    func deleteUserQuote(quoteID : String, completionHandler: (Bool) -> ())
    {
        // Fetch user information from database
        let user = db.getUserInformation();
        // Begin deleting from the child node affliated with the UID and quoteID
        let userQuoteChildren = ref.childByAppendingPath("UserQuotes/"+user.uid+"/"+quoteID);
        
        userQuoteChildren.removeValue();
        db.deleteQuotation(quoteID);
        completionHandler(true);
    }
    
    // Push a liked quote to Firebase affliated with the user's UID
    // @params: quote : apiQuote
    // @return: void
    func pushUserQuote(quote : apiQuote,completionHandler: (Bool) -> ())
    {
        // Fetch user information from database
        let user = db.getUserInformation();
        // Begin traversing from the child node affliated with the user ID
        let userQuoteChildren = ref.childByAppendingPath("UserQuotes").childByAppendingPath(user.uid);
        // Create a quote array which holds the data passed in
        let quote_array =
            [
                "author"    : quote.author,
                "liked"     : true,
                "quote"     : quote.quote,
                "category"  : quote.category
            ];
        // Create a key->value dictionary for the quote affliated with the quote ID
        let _quote = [quote.id : quote_array];
        // Set quote in Firebase
        userQuoteChildren.updateChildValues(_quote);
        // Set quote in Local Database
        quote.liked = true;
        db.insertUserQuoteData(quote);
        completionHandler(true);
    }
    // Push a response to Firebase affliated with the user's UID
    // @params: response : ResponseData
    // @return: void
    func pushUserResponse(response: ResponseData,completionHandler: (Bool) -> ())
    {
        // Fetch user information from database
        let user = db.getUserInformation();
        // Begin traversing from the child node affliated with the user ID
        let userResponseChildren = ref.childByAppendingPath("UserResponses").childByAppendingPath(user.uid);
        // Create a response array which holds the data passed in
        let response_array =
            [
                "date"      : String(response.date),
                "response"  : response.response,
                "feeling"   : response.feeling
        ];
        // Create a key->value dictionary for the quote affliated with the response Date
        let _response = [String(response.date) : response_array];
        // Set response in Firebase
        userResponseChildren.updateChildValues(_response);
        db.insertResponseData(response);
        completionHandler(true);
    }
    
    // Push a response to Firebase
    // @params: music : MusicNode
    // @return: void
    func pushUserMusic(music: MusicNode,completionHandler: (Bool) -> ())
    {
        // Fetch user information from database
        let user = db.getUserInformation();
        // Begin traversing from the child node affliated with the user ID
        let userMusicChildren = ref.childByAppendingPath("UserMusic/"+user.uid).childByAppendingPath(music.prefix);
        // Create a quote array which holds the data passed in
        let music_array =
            [
                "prefix"    : music.prefix,
                "musicURL"  : music.musicURL,
                "title"     : music.title,
                "liked"     : true
        ];
        // Create a key->value dictionary for the quote affliated with the quote ID
        let _music = [music.musicID : music_array];
        // Set quote in Firebase
        userMusicChildren.updateChildValues(_music);
        // Set quote in Local Database
        music.liked = true;
        db.insertUserMusicData(music);
        completionHandler(true);
    }
    
    func retrieveUserData(uid: String, completionHandler: (Bool) -> ())
    {
        
        // Obtain user information from Firebase
        ref.childByAppendingPath("Users").observeSingleEventOfType(
            FEventType.Value, withBlock: { (snapshot) -> Void in
                
                // Check existance in local database and insert if absent
                for child in snapshot.children
                {
                    if(child.key == uid)
                    {
                        // Obtain child keys and assign them to an object
                        let childSnapshot = snapshot.childSnapshotForPath(child.key);
                        let uid = childSnapshot.value["uid"] as! String;
                        let email = childSnapshot.value["email"] as! String;
                        let fname = childSnapshot.value["firstname"] as! String;
                        let lname = childSnapshot.value["lastname"] as! String;
                        
                        // Create user object
                        let new_obj = User(uid: uid, email: email, firstname: fname, lastname: lname);
                        
                        // Insert into database
                        self.db.insertUserSessionData(new_obj);
                        
                        // Fetch users stored quotes
                        self.ref.childByAppendingPath("UserQuotes/"+uid).observeSingleEventOfType(
                            FEventType.Value, withBlock: { (snapshot) -> Void in
                            
                            // Check existance in child nodes
                            for quoteChild in snapshot.children
                            {
                                let quoteSnapshot = snapshot.childSnapshotForPath(quoteChild.key);
                                let id = quoteChild.key;
                                let author = quoteSnapshot.value["author"] as! String;
                                let quote = quoteSnapshot.value["quote"] as! String;
                                let liked = quoteSnapshot.value["liked"] as! Bool;
                                let category = quoteSnapshot.value["category"] as! String;
                                
                                // Create quote object
                                let quote_obj = apiQuote(id: id, quote: quote, author: author, liked: liked,category: category);
                                
                                // Insert into database
                                self.db.insertUserQuoteData(quote_obj);
                            }
                        })
                        // Fetch user stored music
                        self.ref.childByAppendingPath("UserMusic/"+uid).observeSingleEventOfType(
                            FEventType.Value, withBlock: { (snapshot) -> Void in
                                
                                // Check existance in child nodes
                                for musicChild in snapshot.children
                                {
                                    let musicSnapshot = snapshot.childSnapshotForPath(musicChild.key);
                                    let prefix = musicChild.key;
                                    for prefixChild in musicSnapshot.children
                                    {
                                        let musicID = prefixChild.key;
                                        let liked = prefixChild.value["liked"] as! Bool;
                                        let musicURL = prefixChild.value["musicURL"] as! String;
                                        let title = prefixChild.value["title"] as! String;
                                        
                                        // Create music object
                                        let music_obj = MusicNode(musicID: musicID, prefix: prefix, musicURL: musicURL, title: title, liked: liked);
                
                                        // Insert into database
                                        self.db.insertUserMusicData(music_obj);
                                    }
                                }
                        })
                        // Fetch user stored responses
                        self.ref.childByAppendingPath("UserResponses/"+uid).observeSingleEventOfType(
                            FEventType.Value, withBlock: { (snapshot) -> Void in
                                
                                // Check existance in child nodes
                                for responseChild in snapshot.children
                                {
                                    let responseSnapshot = snapshot.childSnapshotForPath(responseChild.key);
                                    let prefix = responseChild.key;
                                    let date = prefix;
                                    let response = responseSnapshot.value["response"] as! String;
                                    let feeling = responseSnapshot.value["feeling"] as! String;
                                    
                                    // Create response object
                                    let response_obj = ResponseData(
                                        date: date,
                                        response: response,
                                        feeling: feeling)
                                    
                                    // Insert into database
                                    self.db.insertResponseData(response_obj);
                                }
                        })
                    }
                }
                // Check if completed. The iterations are finished when the next value is null.
                // Pass this to the completion handler so we know when to insert the data into
                // memory.
                if snapshot.value is NSNull {
                    completionHandler(false)
                } else {
                    completionHandler(true)
                }
        })

    }
    // Retrieve meditation data from Firebase and insert in local database for the
    // applications duration
    // @return: void
    func retrieveMeditationData(completionHandler: (Bool) -> ())
    {
        // Delete rows from the table so we don't have duplicates
        try! db.db.run(db.meditation.delete());
        
        // Lopp through all children in the meditaiton data tree in Firebase
        ref.childByAppendingPath("meditationData").observeSingleEventOfType(
            FEventType.Value, withBlock: { (snapshot) -> Void in
            
                // Check existance in local database and insert if absent
                for child in snapshot.children {
                    
                    // Obtain child keys and assign them to an object
                    let childSnapshot = snapshot.childSnapshotForPath(child.key);
                    let index = childSnapshot.value["index"] as! String;
                    let image = childSnapshot.value["image"] as! String;
                    let title = childSnapshot.value["title"] as! String;
                    let description = childSnapshot.value["description"] as! String;
                    
                    // Create the object. Note we will use index as the 'key'
                    let new_obj = MeditationData(index: index, image: image, dataTitle: title, dataBody: description);
                    // Insert into database
                    self.db.insertMeditationData(new_obj);
                }
                // Fetch stored music
                self.ref.childByAppendingPath("musicData").observeSingleEventOfType(
                    FEventType.Value, withBlock: { (snapshot) -> Void in
                        
                        // Check existance in child nodes
                        for musicChild in snapshot.children
                        {
                            let musicSnapshot = snapshot.childSnapshotForPath(musicChild.key);
                            let prefix = musicChild.key;
                            for prefixChild in musicSnapshot.children
                            {
                                let musicID = prefixChild.key;
                                let musicURL = prefixChild.value["musicURL"] as! String;
                                let imageURL = prefixChild.value["imageURL"] as! String;
                                let title = prefixChild.value["title"] as! String;
                                
                                // Create music object
                                let music_obj = MusicDataNode(musicID: musicID, prefix: prefix, musicURL: musicURL,imageURL: imageURL, title: title);
                                
                                // Insert into database
                                self.db.insertMusicData(music_obj);
                                self.db.musicToMemory();
                            }
                        }
                })
                // Fetch stored images
                self.ref.childByAppendingPath("imageData").observeSingleEventOfType(
                    FEventType.Value, withBlock: { (snapshot) -> Void in
                        
                        // Check existance in local database and insert if absent
                        for child in snapshot.children {
                            
                            // Obtain child keys and assign them to an object
                            let childSnapshot = snapshot.childSnapshotForPath(child.key);
                            let index = child.key;
                            let imageSRC = childSnapshot.value["imageSRC"] as! String;
                            
                            // Create the object. Note we will use index as the 'key'
                            let new_obj = ImageData(
                                index: Int(index)!,
                                imageSRC: imageSRC);
                            // Insert into database
                            self.model.imageData.append(new_obj);
                        }

                })
                // Check if completed. The iterations are finished when the next value is null.
                // Pass this to the completion handler so we know when to insert the data into
                // memory.
                if snapshot.value is NSNull {
                    completionHandler(false)
                } else {
                    completionHandler(true)
                }
        })
    }
}
