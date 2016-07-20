//
//  AppDelegate.swift
//  Alpha
//
//  Created by Max Yendall on 29/03/2016.
//  Copyright © 2016 RMIT. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var shouldSupportAllOrientation = false
    
    
    // Application function
    func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> UIInterfaceOrientationMask {
        
        // Ensure the all orientations are supported
        if (shouldSupportAllOrientation == true){
            return UIInterfaceOrientationMask.All
        }
        
        return UIInterfaceOrientationMask.All;
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func getHeightforController(view: AnyObject) -> CGFloat {
        let tempView: UILabel = view as! UILabel
        let context: NSStringDrawingContext = NSStringDrawingContext()
        context.minimumScaleFactor = 0.8
        
        var width: CGFloat = tempView.frame.size.width
        
        width = ((UIScreen.mainScreen().bounds.width)/320)*width
        
        let size: CGSize = tempView.text!.boundingRectWithSize(CGSizeMake(width, 2000), options:NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: tempView.font], context: context).size as CGSize
        
        return size.height
    }
    
    
}

