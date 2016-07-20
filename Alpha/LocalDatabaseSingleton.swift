//
//  LocalDatabaseSingleton.swift
//  Alpha
//
//  Created by Max Yendall on 20/04/2016.
//  Copyright © 2016 RMIT. All rights reserved.
//

import Foundation
import SQLite

class LocalDatabaseSingleton
{
    // Singleton Use
    static let sharedInstance = LocalDatabaseSingleton();
    // Database connection
    var db : SQLite.Connection;
    // Model Reference
    let model = ModelData.sharedInstance;
    
    // ID can be used for all tables if need be
    let id      = Expression<Int>("id");
    let key     = Expression<String>("key");
    
    // Users Table
    let uid     = Expression<String?>("uid");
    let uname   = Expression<String?>("name");
    let fname   = Expression<String?>("fname");
    let lname   = Expression<String?>("lname");
    let pw_key  = Expression<String?>("pw_key");
    
    // Meditation Table
    let title   = Expression<String?>("title");
    let image   = Expression<String?>("image");
    let desc    = Expression<String?>("description");
    
    // Feelings Table
    let date    = Expression<String?>("date");
    let response = Expression<String?>("response");
    let feeling  = Expression<String?>("feeling");
    
    // Music Table
    let prefix  = Expression<String?>("suffix");
    let musicID = Expression<String?>("musicID");
    let URL     = Expression<String?>("URL");
    let imageURL = Expression<String?>("imageURL");
    
    // Quote Table
    let liked   = Expression<Bool?>("liked");
    let quote   = Expression<String?>("quote");
    let author  = Expression<String?>("author");
    let quoteID = Expression<String?>("quoteid");
    let category = Expression<String?>("category");
    
    // Tables
    let users       = Table("USERS");
    let usermusic   = Table("USERMUSIC");
    let music       = Table("MUSIC");
    let quotes      = Table("QUOTES");
    let feelings    = Table("FEELINGS");
    let meditation  = Table("MEDITATION");
    
    
    // Initialise the database and Create tables if they don't already exist
    init()
    {
        // Search for the database in the Document Directory
        let path = NSSearchPathForDirectoriesInDomains(
            .DocumentDirectory, .UserDomainMask, true
            ).first!
        
        // Initialise connection to database
        db = try! Connection("\(path)/db.sqlite3");
        debugPrint("\(path)/db.sqlite3");
        
        try! db.run(users.drop(ifExists: true));
        try! db.run(usermusic.drop(ifExists: true));
        try! db.run(feelings.drop(ifExists: true));
        try! db.run(quotes.drop(ifExists: true));
        try! db.run(music.drop(ifExists: true));
        
        // Create the users table, if it doesn't already exist
        try! db.run(users.create(ifNotExists: true)
        {
            t in
            t.column(id, primaryKey: .Autoincrement)
            t.column(uid, unique: true)
            t.column(uname, unique: true)
            t.column(fname)
            t.column(lname)
            t.column(pw_key)
        });
        
        // Create the meditation table, if it doesn't already exist
        try! db.run(meditation.create(ifNotExists: true)
        {
            t in
            t.column(id, primaryKey: .Autoincrement)
            t.column(key)
            t.column(title)
            t.column(image)
            t.column(desc)
            
        });
        
        // Create the feelings table, if it doesn't already exist
        try! db.run(feelings.create(ifNotExists: true)
        {
            t in
            t.column(id, primaryKey: .Autoincrement)
            t.column(date)
            t.column(response)
            t.column(feeling)
        });
        
        // Create the music table, if it doesn't already exist
        try! db.run(usermusic.create(ifNotExists: true)
        {
            t in
            t.column(id, primaryKey: .Autoincrement)
            t.column(musicID)
            t.column(prefix)
            t.column(URL)
            t.column(title)
            t.column(liked)
            
        });
        
        // Create the quotes table, if it doesn't already exist
        try! db.run(quotes.create(ifNotExists: true)
        {
            t in
            t.column(id, primaryKey: .Autoincrement)
            t.column(quoteID)
            t.column(quote)
            t.column(author)
            t.column(liked)
            t.column(category)
        });
        
        // Create the music table, if it doesn't already exist
        try! db.run(music.create(ifNotExists: true)
        {
            t in
            t.column(id, primaryKey: .Autoincrement)
            t.column(musicID)
            t.column(prefix)
            t.column(URL)
            t.column(title)
            t.column(imageURL)
            
            });
    }
    
    // Return the saved history affliliated with the user
    // @return: musicArray : [MusicNode]
    func getUserResponses()->[ResponseData]
    {
        var responseArray = [ResponseData]();
        
        for _response in try! db.prepare(feelings)
        {
            let r = ResponseData(
                date: _response[date]!,
                response: _response[response]!,
                feeling: _response[feeling]!
            )
            
            responseArray.append(r);
        }
        
        return responseArray;
    }
    // Return the data affliated with the user
    // @return: user : User
    func getUserInformation()->User
    {
        var user = User(
            uid: "",
            email: "",
            firstname: "",
            lastname: ""
        );
        
        for _user in try! db.prepare(users)
        {
            let u = User(
                uid: _user[uid]!,
                email: _user[uname]!,
                firstname: _user[fname]!,
                lastname: _user[lname]!
            )
            user = u;
        }
        return user;
    }
    // Return the save music affliliated with the user
    // @return: musicArray : [MusicNode]
    func getUserMusic()->[MusicNode]
    {
        var musicArray = [MusicNode]();
        
        for _music in try! db.prepare(usermusic)
        {
            let m = MusicNode(
                musicID: _music[musicID]!,
                prefix: _music[prefix]!,
                musicURL: _music[URL]!,
                title: _music[title]!,
                liked: _music[liked]!
            )
            musicArray.append(m);
        }
        
        return musicArray;
    }
    
    // Return the saved quotes affliliated with the user
    // @return: quoteArray: [apiQuote]
    func getUserQuotes()->[apiQuote]
    {
        var quoteArray = [apiQuote]();
        
        for _quote in try! db.prepare(quotes)
        {
            let q = apiQuote(
                id:         _quote[quoteID]!,
                quote:      _quote[quote]!,
                author:     _quote[author]!,
                liked:      _quote[liked]!,
                category:   _quote[category]!
            )
            quoteArray.append(q);
        }
        
        return quoteArray;
    }
    
    // Delete music from database based on ID
    // @params: musicID : String
    // @return: void
    func deleteMusic(id : String, _prefix : String)
    {
        let _music = usermusic.filter(id == musicID && _prefix == prefix);
        try! db.run(_music.delete());
    }
    
    // Delete quutation from database based on ID
    // @params: quoteID : String
    // @return: void
    func deleteQuotation(id : String)
    {
        let quote = quotes.filter(id == quoteID);
        try! db.run(quote.delete());
    }
    
    // Search for whether a quotation has been liked or not
    // @params: id of the quote
    // @return: boolean value
    func searchQuotation(id : String)->Bool
    {
        for quote in try! db.prepare(quotes)
        {
            
            if(quote[quoteID] == id)
            {
                return quote[liked]!;
            }
        }
        
        return false;
    }
    
    // Search for whether a song has been liked or not
    // @params: id of the song
    // @return: boolean value
    func searchMusic(id : String, _prefix: String)->Bool
    {
        for _music in try! db.prepare(usermusic)
        {
            if(_music[musicID] == id && _music[prefix] == _prefix)
            {
                return _music[liked]!;
            }
        }
        
        return false;
    }
    
    // Insert music data into the table
    // @params: data : MusicNode
    // @return: void
    func insertMusicData(data : MusicDataNode)
    {
        // Run with new meditation data
        do {
            _ = try db.run(
                music.insert(or: .Replace,
                    musicID <- data.musicID,
                    prefix <- data.prefix,
                    title <- data.title,
                    imageURL <- data.imageURL,
                    URL <- data.musicURL
                )
            )
            // Successful insertion
        } catch {
            debugPrint("insertion failed: \(error)");
        }
    }
    
    // Insert response data into the table
    // @params: data : MeditationData
    // @return: void
    func insertMeditationData(data : MeditationData)
    {
        // Run with new meditation data
        do {
            _ = try db.run(
                meditation.insert(or: .Replace,
                    key <- data.index,
                    title <- data.dataTitle,
                    image <- data.image,
                    desc <- data.dataBody
                )
            )
            // Successful insertion
        } catch {
            debugPrint("insertion failed: \(error)");
        }
    }
    // Insert meditation data into the table
    // @params: data : MeditationData
    // @return: void
    func insertResponseData(data : ResponseData)->Bool
    {
        
        // Run with new meditation data
        do {
            _ = try db.run(
                feelings.insert(or: .Replace,
                    date <- data.date,
                    response <- data.response,
                    feeling <- data.feeling
                )
            )
            // Successful insertion
        } catch {
            debugPrint("insertion failed: \(error)");
        }
        return true;
    }
    
    // Insert userMusic data into the table (session based)
    // @params: data : MusicNode
    // @return: void
    func insertUserMusicData(data : MusicNode)
    {
        do {
            _ = try db.run(
                usermusic.insert(or: .Replace,
                    musicID <- data.musicID,
                    prefix <- data.prefix,
                    title <- data.title,
                    URL <- data.musicURL,
                    liked <- data.liked
                )
            )
        } catch {
            debugPrint("insertion failed: \(error)");
        }
    }
    // Insert userQuote data into the table (session based)
    // @params: data : User
    // @return: void
    func insertUserQuoteData(data : apiQuote)
    {
        
        // Run with new userQuote data
        do {
            _ = try db.run(
                quotes.insert(or: .Replace,
                    quoteID <- data.id,
                    author <- data.author,
                    quote <- data.quote,
                    liked <- data.liked,
                    category <- data.category
                )
            )
            // Successful insertion
        } catch {
            debugPrint("insertion failed: \(error)");
        }
    }
    
    // Insert user data into the table (session based)
    // @params: data : User
    // @return: void
    func insertUserSessionData(data : User)
    {
        
        // Run with new user data
        do {
            _ = try db.run(
                users.insert(or: .Replace,
                    uid <- data.uid,
                    uname <- data.email,
                    fname <- data.firstname,
                    lname <- data.lastname
                )
            )
            // Successful insertion
        } catch {
            debugPrint("insertion failed: \(error)");
        }
    }
    
    // Insert user session data into memory for reading
    // @return: void
    func userToMemory()
    {
        for data in try! db.prepare(users)
        {
            // Create a new user object
            let new_obj = User(
                uid: data[uid]!,
                email: data[uname]!,
                firstname: data[fname]!,
                lastname: data[lname]!
            )
            // Append it to the model
            model.userData.append(new_obj);
        }
    }
    // Insert meditation data into memory for reading
    // @return: void
    func meditationToMemory()
    {
        for data in try! db.prepare(meditation)
        {
            // Create a new object
            let new_obj = MeditationData(
                index: data[key],
                image: data[image]!,
                dataTitle: data[title]!,
                dataBody: data[desc]!)
            // Append it to the model
            model.meditationData.append(new_obj);
           
        }
    }
    // Insert meditation data into memory for reading
    // @return: void
    func musicToMemory()
    {
        for data in try! db.prepare(music)
        {
            // Create a new object
            let new_obj = MusicDataNode(
                musicID: data[musicID]!,
                prefix: data[prefix]!,
                musicURL: data[URL]!,
                imageURL: data[imageURL]!,
                title: data[title]!)
            
            // Append it to the model
            if(data[prefix] == "Theta")
            {
                model.thetaData.append(new_obj);
            }
            else
            {
                model.alphaData.append(new_obj);
            }
        }
    }
}