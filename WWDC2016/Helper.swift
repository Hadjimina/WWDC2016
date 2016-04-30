//
//  Helper.swift
//  WWDC2016
//
//  Created by Philipp Hadjimina on 24/04/16.
//  Copyright © 2016 Philipp Hadjimina. All rights reserved.
//

import UIKit
import MapKit

// MARK: Helper Functions

func showSimpleAlertWithTitle(title: String!, message: String, viewController: UIViewController) {
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    let action = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
    alert.addAction(action)
    viewController.presentViewController(alert, animated: true, completion: nil)
}


func registerNotification() {
	
	// 1. Create the actions **************************************************
	
	// increment Action
	let incrementAction = UIMutableUserNotificationAction()
	incrementAction.identifier = "2"
	incrementAction.title = "Show Event"
	incrementAction.activationMode = UIUserNotificationActivationMode.Foreground
	incrementAction.authenticationRequired = true
	incrementAction.destructive = false
	
	// decrement Action
	let decrementAction = UIMutableUserNotificationAction()
	decrementAction.identifier = "1"
	decrementAction.title = "Dismiss"
	decrementAction.activationMode = UIUserNotificationActivationMode.Background
	decrementAction.authenticationRequired = true
	decrementAction.destructive = false
	
	// reset Action
	let resetAction = UIMutableUserNotificationAction()
	resetAction.identifier = "0"
	resetAction.title = "RESET"
	resetAction.activationMode = UIUserNotificationActivationMode.Foreground
	// NOT USED resetAction.authenticationRequired = true
	resetAction.destructive = true
	
	
	// 2. Create the category ***********************************************
	
	// Category
	let counterCategory = UIMutableUserNotificationCategory()
	counterCategory.identifier = "hi"
	
	// A. Set actions for the default context
	counterCategory.setActions([incrementAction],
	                           forContext: UIUserNotificationActionContext.Default)
	
	// B. Set actions for the minimal context
	counterCategory.setActions([incrementAction],
	                           forContext: UIUserNotificationActionContext.Minimal)
	
	
	// 3. Notification Registration *****************************************
	
	let types: UIUserNotificationType = [UIUserNotificationType.Alert, UIUserNotificationType.Sound]
	let settings = UIUserNotificationSettings(forTypes: types, categories: NSSet(object: counterCategory) as! Set<UIUserNotificationCategory>)
	UIApplication.sharedApplication().registerUserNotificationSettings(settings)
}


// Returns the most recently presented UIViewController (visible)
 func getCurrentViewController() -> UIViewController? {
	
    // Otherwise, we must get the root UIViewController and iterate through presented views
    if let rootController = UIApplication.sharedApplication().keyWindow?.rootViewController {
        
        var currentController: UIViewController! = rootController
        
        // Each ViewController keeps track of the view it has presented, so we
        // can move from the head to the tail, which will always be the current view
        while( currentController.presentedViewController != nil ) {
            
            currentController = currentController.presentedViewController
        }
        return currentController
    }
    return nil
}

func notefromRegionIdentifier(identifier: String) -> String? {
    var message1 = "You are near an important location in "
    let message2 = "s life"
    
    print("idetn :"+identifier)
    if identifier == "Albert Einstein" {
        message1 = message1 + "Albert Einstein"
    }
    else if identifier == "Mahatma Gandhi" {
        message1 = message1 + "Mahatma Gandhi"
    }else if identifier == "Martin Luther King"{
        message1 = message1 + "Martin Luther King"
    }
    
    return message1+message2
}

func stopMonitoringLocations(locationManager:CLLocationManager, defaults:NSUserDefaults) {
    for region in locationManager.monitoredRegions {
        if let circularRegion = region as? CLCircularRegion {
            locationManager.stopMonitoringForRegion(circularRegion)
        }
    }
    
    defaults.setObject("NoOne", forKey: "toBeWatched")
}

func userAlreadyExist() -> Bool {
    let defaults = NSUserDefaults.standardUserDefaults()
    if (defaults.stringForKey("toBeWatched") != nil) {
        return true
    }
    return false
}


func notifcationValueAlreadyExist() -> Bool {
    let defaults = NSUserDefaults.standardUserDefaults()
    if (defaults.stringForKey("fromNotification") != nil) {
        return true
    }
    return false
}