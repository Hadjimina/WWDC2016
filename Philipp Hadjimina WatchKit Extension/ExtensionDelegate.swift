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
    
    func didReceiveLocalNotification(notification: UILocalNotification) {
        print(notification.alertBody)
        
        /* let adsf = notification.alertBody
         var person = "Mahatma Gandhi"
         if adsf!.rangeOfString("Gandhi") != nil{
         person = "Mahatma Gandhi"
         
         }else if adsf!.rangeOfString("King") != nil {
         person = "Martin Luther King"
         
         }else if adsf!.rangeOfString("Einstein") != nil{
         person = "Albert Einstein"
         }
         
         NSUserDefaults.standardUserDefaults().setObject(person as String, forKey: "toBeWatched")
         NSUserDefaults.standardUserDefaults().setObject("true" as String, forKey: "dummy")*/
        
    }
    
    
    func session(session: WCSession, didReceiveUserInfo userInfo: [String : AnyObject]) {
        print("potato1")
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            print("potato2")
            print("User info "+String(userInfo))
            // let items = NSUserDefaults.standardUserDefaults().objectForKey("toBeWatched") as? String
            
            print("potato3")
            let dummy = userInfo["dummy"] as! String
            let watcher = userInfo["toBeWatched"] as! String
            
            print("Watcher " + watcher)
            print(dummy)
            
            print("potato4")
            NSUserDefaults.standardUserDefaults().setObject(watcher as String, forKey: "toBeWatched")
            NSUserDefaults.standardUserDefaults().setObject(dummy as String, forKey: "dummy")
            
        }
        
    }
}