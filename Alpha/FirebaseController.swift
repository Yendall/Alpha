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

class FirebaseController
{
    init()
    {
        firebase_fetch();
    }
    
    func firebase_fetch()
    {
        debugPrint("reaches here");
        let ref = Firebase(url:"https://max-alpha.firebaseio.com/")
        ref.childByAppendingPath("0").observeSingleEventOfType(
            FEventType.Value, withBlock: { (snapshot) -> Void in
                
                for child in snapshot.children {
                    
                    let childSnapshot = snapshot.childSnapshotForPath(child.key)
                    let someValue = childSnapshot.value["musicURL"] as! String
                    
                    print(someValue);
                }
        })
    }
}
