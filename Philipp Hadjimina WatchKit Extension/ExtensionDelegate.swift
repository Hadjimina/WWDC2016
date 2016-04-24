//
//  ExtensionDelegate.swift
//  Philipp Hadjimina WatchKit Extension
//
//  Created by Philipp Hadjimina on 24/04/16.
//  Copyright © 2016 Philipp Hadjimina. All rights reserved.
//

import WatchKit
import WatchConnectivity

class ExtensionDelegate: NSObject, WKExtensionDelegate, WCSessionDelegate {
    
    var session: WCSession!
    
    func applicationDidFinishLaunching() {
        session = WCSession.defaultSession()
        session.delegate = self
        session.activateSession()
    }
    
    func applicationDidBecomeActive() {
        
    }
    
    func applicationWillResignActive() {
        
    }
    

    func session(session: WCSession, didReceiveUserInfo userInfo: [String : AnyObject]) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
            if let item = NSUserDefaults.standardUserDefaults().objectForKey("toBeWatched") as? String {

                NSUserDefaults.standardUserDefaults().setObject(item, forKey: "toBeWatched")
            } else {
                NSUserDefaults.standardUserDefaults().setObject([userInfo], forKey: "toBeWatched")
            }
        }
    }
}