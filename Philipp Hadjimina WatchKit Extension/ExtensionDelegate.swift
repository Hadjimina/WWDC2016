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
        print("asdf")
        
        let adsf = notification.alertBody
        var person = "Mahatma Gandhi"
        if adsf!.rangeOfString("Gandhi") != nil{
            person = "Mahatma Gandhi"

        }else if adsf!.rangeOfString("King") != nil {
            person = "Martin Luther King"

        }else if adsf!.rangeOfString("Einstein") != nil{
            person = "Albert Einstein"
                    }
        
        NSUserDefaults.standardUserDefaults().setObject(person as String, forKey: "toBeWatched")
        NSUserDefaults.standardUserDefaults().setObject("true" as String, forKey: "dummy")
        
    }
    
    
    func session(session: WCSession, didReceiveUserInfo userInfo: [String : AnyObject]) {
        print("potato1")
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            print("potato2")
            let items = NSUserDefaults.standardUserDefaults().objectForKey("toBeWatched") as? String
        
                print("potato3")
                if let dummy = NSUserDefaults.standardUserDefaults().objectForKey("dummy") as? String{
                    print("potato4")
                    NSUserDefaults.standardUserDefaults().setObject(items! as String, forKey: "toBeWatched")
                    NSUserDefaults.standardUserDefaults().setObject(dummy as String, forKey: "dummy")
                }
        
        }
    }
    
    
   /* func session(session: WCSession, didReceiveUserInfo userInfo: [String : AnyObject]) {
        print("potato")
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            print("potato")
            if let items = NSUserDefaults.standardUserDefaults().objectForKey("toBeWatched") as? String  {
                
                if let dummy = NSUserDefaults.standardUserDefaults().objectForKey("dummy") as? String{
                    
                    NSUserDefaults.standardUserDefaults().setObject(items as String, forKey: "toBeWatched")
                    NSUserDefaults.standardUserDefaults().setObject(dummy as String, forKey: "dummy")
                }
            }else {
                NSUserDefaults.standardUserDefaults().setObject([userInfo] as AnyObject, forKey: "toBeWatched")
            }
        }
    }*/
    
   
}