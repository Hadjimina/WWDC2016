//
//  Artwork.swift
//  WWDC2016
//
//  Created by Philipp Hadjimina on 23/04/16.
//  Copyright © 2016 Philipp Hadjimina. All rights reserved.
//


import MapKit

class Artwork: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    let person:String
    let year: String
    
    
    init(title: String, locationName: String, location: CLLocation) {
        self.title = title
        self.locationName = locationName
        self.coordinate = location.coordinate
        
        let dataFromTitle = title.componentsSeparatedByString(": ")
        self.person = dataFromTitle[0]
        self.year = dataFromTitle[1]
        super.init()
    }

    var subtitle: String? {
        return locationName
    }
    
    
}