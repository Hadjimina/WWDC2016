//
//  AppDelegate.swift
//  WWDC2016
//
//  Created by Philipp Hadjimina on 22/04/16.
//  Copyright © 2016 Philipp Hadjimina. All rights reserved.
//

import UIKit
import CoreLocation
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate, WCSessionDelegate {
    
    var window: UIWindow?
    let locationManager = CLLocationManager()
    var session: WCSession!
    var alertShown = false
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
		
		registerNotification()
		
        //Geo
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        application.registerUserNotificationSettings(
            UIUserNotificationSettings(
                forTypes: [.Alert, .Badge, .Sound],
                categories: nil))
        
        
        //Watch communication
        session = WCSession.defaultSession()
        session.delegate = self
        
        if WCSession.isSupported() {
            session.activateSession()
        }
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("page")
        window?.rootViewController = vc
        
        
        if let payload = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] as? NSDictionary, identifier = payload["identifier"] as? String {
            
            print("potato")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier(identifier)
            window?.rootViewController = vc
        }
		
		
        return true
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
    
    //Geo
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion {
            handleRegionEvent(region)
        }
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region is CLCircularRegion {
            handleRegionEvent(region)
        }
    }
    
    func handleRegionEvent(region: CLRegion!) {
        // Show an alert if application is active
        if UIApplication.sharedApplication().applicationState == .Active {
            let application = UIApplication.sharedApplication()
            alertHandler(application)
        } else {
            // Otherwise present a local notification
            
            let notification = UILocalNotification()
            notification.alertTitle = "Encounter"
            notification.alertBody = notefromRegionIdentifier(region.identifier)
            notification.soundName = UILocalNotificationDefaultSoundName
            //.fireDate = NSDate(timeIntervalSinceNow: 10)
            notification.category = "hi"
            UIApplication.sharedApplication().presentLocalNotificationNow(notification)
        }
    }
    
    func application(application: UIApplication, handleWatchKitExtensionRequest userInfo: [NSObject : AnyObject]?, reply: ([NSObject : AnyObject]?) -> Void) {
        // retrieved parameters from Apple Watch
        print(userInfo!["value1"])
        print(userInfo!["value2"])
        
        // pass back values to Apple Watch
        var retValues = Dictionary<String,String>()
        
        retValues["retVal1"] = "return Test 1"
        retValues["retVal2"] = "return Test 2"
        
        reply(retValues)
        
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        
        let state = application.applicationState
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if (state ==  UIApplicationState.Inactive || state ==  UIApplicationState.Background) {
            
            let rootVC = storyboard.instantiateViewControllerWithIdentifier("page") as! RootViewController
            let locationVC = storyboard.instantiateViewControllerWithIdentifier("location") as! LocationViewController
            self.window?.rootViewController = rootVC
            
            locationVC.data = defaults.stringForKey("toBeWatched")
            
            //Hack notification solution
            defaults.setObject("true", forKey: "fromNotification")
            rootVC.performSegueWithIdentifier("notificationLoad", sender: nil)
        } else {
            
            UIApplication.sharedApplication().cancelAllLocalNotifications()
            alertHandler(application)
        }
    }
    
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        stopMonitoringLocations(locationManager,defaults: defaults)
        
    }
    

    
    func alertHandler(app: UIApplication)  {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let defaults = NSUserDefaults.standardUserDefaults()
        var topController : UIViewController = (app.keyWindow?.rootViewController)!
        while ((topController.presentedViewController) != nil) {
            topController = topController.presentedViewController!
        }
        
        
        if !alertShown {
		
            let alert = UIAlertController(title: "Encounter", message: notefromRegionIdentifier(defaults.stringForKey("toBeWatched")!), preferredStyle: UIAlertControllerStyle.Alert)
            
            let okAction = UIAlertAction(title: "Show Location", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                self.performSegueToCorrectVC()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
                UIAlertAction in
                self.alertShown = false
            }
            
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            
            topController.presentViewController(alert, animated: true, completion: nil)
            alertShown = true
        }
    }
	
	func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
		registerNotification()
	}
	
	
	func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        
        
		switch identifier {
		case "2"?:            
            performSegueToCorrectVC()
        default:
			break
		}

		completionHandler()
	}
    
    func performSegueToCorrectVC()  {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject("true", forKey: "fromNotification")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: RootViewController = storyboard.instantiateViewControllerWithIdentifier("page") as! RootViewController
        
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
}


