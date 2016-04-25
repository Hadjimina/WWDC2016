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


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
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
        
        
        //notification
        print(launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey])
        
        if let payload = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] as? NSDictionary, identifier = payload["identifier"] as? String {
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
    
    func notefromRegionIdentifier(identifier: String) -> String? {        
        var message1 = "You are near an important location in "
        let message2 = "s life"
        
        if identifier.rangeOfString("Alber Einstein") != nil{
            message1 = message1 + "Alber Einstein"
        }
        else if identifier.rangeOfString("Mahatma Gandhi") != nil{
            message1 = message1 + "Mahatma Gandhi"
        }else{
            message1 = message1 + "Martin Luther King"
        }
        
        return message1+message2
    }
    
    func handleRegionEvent(region: CLRegion!) {
        // Show an alert if application is active
        if UIApplication.sharedApplication().applicationState == .Active {
            if let message = notefromRegionIdentifier(region.identifier) {
                if let viewController = window?.rootViewController {
                    showSimpleAlertWithTitle(nil, message: message, viewController: viewController)
                }
            }
        } else {
            // Otherwise present a local notification
            let notification = UILocalNotification()
            notification.alertBody = notefromRegionIdentifier(region.identifier)
            notification.soundName = "Default";
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
        
       /* let defaults = NSUserDefaults.standardUserDefaults()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootVC = storyboard.instantiateViewControllerWithIdentifier("page") as! RootViewController
        let locationVC = storyboard.instantiateViewControllerWithIdentifier("location") as! LocationViewController
        
        locationVC.data = defaults.stringForKey("toBeWatched")
        rootVC.visibleViewController.navigationController?.pushViewController(locationVC, animated: true)
        
 
        
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        var viewController: LocationViewController = storyboard.instantiateViewControllerWithIdentifier("location") as! LocationViewController
        
        // Then push that view controller onto the navigation stack
        var rootViewController = self.window!.rootViewController as! RootViewController
        rootViewController.pushViewController(viewController, animated: true)
        */
        let state = application.applicationState
        
        if (state ==  UIApplicationState.Inactive || state ==  UIApplicationState.Background) {
            let defaults = NSUserDefaults.standardUserDefaults()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let rootVC = storyboard.instantiateViewControllerWithIdentifier("page") as! RootViewController
            let locationVC = storyboard.instantiateViewControllerWithIdentifier("location") as! LocationViewController
            self.window?.rootViewController = rootVC
            locationVC.data = defaults.stringForKey("toBeWatched")
            
            //Hack notification solution
            defaults.setObject("true", forKey: "fromNotification")
            
            rootVC.performSegueWithIdentifier("notificationLoad", sender: nil)

        } else {

        }
    }
    

}

