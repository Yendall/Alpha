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
    
    // ID can be used for all tables if need be
    let id      = Expression<Int>("id");
    
    // Users Table
    let uname   = Expression<String?>("name");
    let fname   = Expression<String?>("fname");
    let lname   = Expression<String?>("lname");
    let pw_key  = Expression<String?>("pw_key");
    
    // Meditation Table
    let title   = Expression<String?>("title");
    let image   = Expression<String?>("image");
    let desc    = Expression<String?>("description");
    
    // Feelings Table
    let time    = Expression<NSDate?>("date");
    let emotion = Expression<Int?>("emotion");
    let status  = Expression<String?>("status");
    
    // Music Table
    let suffix  = Expression<String?>("suffix");
    let URL     = Expression<String?>("URL");
    
    // Initialise the database and Create tables if they don't already exist
    init()
    {
        // Search for the database in the Document Directory
        let path = NSSearchPathForDirectoriesInDomains(
            .DocumentDirectory, .UserDomainMask, true
            ).first!
        
        // Initialise connection to database
        db = try! Connection("\(path)/db.sqlite3");
        
        var tables = [Table]();
        
        // Testing some table creation, use this as a template
        let users       = Table("USERS");
        let meditation  = Table("MEDITATION");
        let feelings    = Table("FEELINGS");
        tables.append(users);
        tables.append(meditation);
        tables.append(feelings);
        
        // Create the users table, if it doesn't already exist
        try! db.run(users.create(ifNotExists: true)
            {
                t in
                t.column(id, primaryKey: .Autoincrement)
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
            t.column(title)
            t.column(image)
            t.column(desc)
            
        });
        
        // Create the feelings table, if it doesn't already exist
        try! db.run(feelings.create(ifNotExists: true)
        {
            t in
            t.column(id, primaryKey: .Autoincrement)
            t.column(uname)
            t.column(emotion)
            t.column(status)
            
        });
        
        // Create the music table, if it doesn't already exist
        try! db.run(feelings.create(ifNotExists: true)
        {
            t in
            t.column(id, primaryKey: .Autoincrement)
            t.column(suffix)
            t.column(URL)
            t.column(title)
            
        });
    }
}

