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

func stopMonitoringLocations(locationManager:CLLocationManager, defaults:NSUserDefaults) {
    for region in locationManager.monitoredRegions {
        if let circularRegion = region as? CLCircularRegion {
            locationManager.stopMonitoringForRegion(circularRegion)
        }
    }
    
    defaults.setObject("NoOne", forKey: "toBeWatched")
}

