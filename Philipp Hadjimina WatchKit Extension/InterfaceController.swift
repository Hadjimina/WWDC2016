//
//  InterfaceController.swift
//  Philipp Hadjimina WatchKit Extension
//
//  Created by Philipp Hadjimina on 24/04/16.
//  Copyright © 2016 Philipp Hadjimina. All rights reserved.
//

import WatchKit
import Foundation
import CoreLocation

class InterfaceController: WKInterfaceController, CLLocationManagerDelegate {
    
    @IBOutlet var mapView: WKInterfaceMap!
    @IBOutlet var descLabel: WKInterfaceLabel!
    var locationManager: CLLocationManager = CLLocationManager()
    var mapLocation: CLLocationCoordinate2D?
    
    var person:NSString!
    
    var currentLocations:[CLLocation]!
    var currentEvents:[String]!
    var currentYears:[String]!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestLocation()
        
        //Setup person
        //Strange encapsulation but works
        let newItems = NSUserDefaults.standardUserDefaults().objectForKey("toBeWatched")![0]
        person = newItems.objectForKey("toBeWatched") as! String
        
        //Setup current location
        if person == "Albert Einstein" {
            currentLocations = getLocationForPersonWithIndex(0)
            currentYears = getYearsForPersonWithIndex(0)
            currentEvents = getEventsForPersonWithIndex(0)
        }else if person == "Mahatma Gandhi"{
            currentLocations = getLocationForPersonWithIndex(1)
            currentYears = getYearsForPersonWithIndex(1)
            currentEvents = getEventsForPersonWithIndex(1)
        }else if person == "Martin Luther King"{
            currentLocations = getLocationForPersonWithIndex(2)
            currentYears = getYearsForPersonWithIndex(2)
            currentEvents = getEventsForPersonWithIndex(2)
        }

        
            print("hello")
        }
    
    override func willActivate() {
        super.willActivate()
        
        
        
        print(person)
        var minDistanceIndex = 0
        
        var getLat: CLLocationDegrees = mapLocation!.latitude
        var getLon: CLLocationDegrees = mapLocation!.longitude
        var mapLocationCL:CLLocation = CLLocation(latitude: getLat, longitude: getLon)
        
        if currentLocations.count != 0 {

            var minDistance = mapLocationCL.distanceFromLocation(currentLocations[0])
            
            for i in 1..<currentLocations.count {
                let distance = mapLocationCL.distanceFromLocation(currentLocations[i])
                if distance < minDistance {
                    minDistance = distance
                    minDistanceIndex = i
                }
            }
            print(minDistanceIndex)
            
        }
        else{
            self.mapView.setHidden(true)
            self.descLabel.setText("You're currently not watching anyone. Add someone to your watchlist in the App on your phone.")
        }

        self.descLabel.setText(currentEvents[minDistanceIndex])
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let currentLocation = locations[0]
        let lat = currentLocation.coordinate.latitude
        let long = currentLocation.coordinate.longitude
        
        self.mapLocation = CLLocationCoordinate2DMake(lat, long)
        
        let span = MKCoordinateSpanMake(0.1, 0.1)
        
        let region = MKCoordinateRegionMake(self.mapLocation!, span)
        self.mapView.setRegion(region)
        
        self.mapView.addAnnotation(self.mapLocation!, withPinColor: .Red)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        print(error.description)
    }
    
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    //Data setup
    func getLocationForPersonWithIndex(index: Int) -> [CLLocation] {
        
        switch index {
            //        case 0:
            
        case 1:
            return [CLLocation(latitude: 21.6417069, longitude: 69.6292654),
                    CLLocation(latitude: 51.512681, longitude: -0.109903),
                    CLLocation(latitude: -29.61083, longitude: 30.36972),
                    CLLocation(latitude: 0, longitude:0),
                    CLLocation(latitude: -29.8753504, longitude: 31.0045807),
                    CLLocation(latitude: -26.2031134, longitude: 28.0270712),
                    CLLocation(latitude: 31.6206437, longitude: 74.8801088),
                    CLLocation(latitude: 37.5334698, longitude:-121.9984011),
                    CLLocation(latitude: 19.0759837, longitude:72.8776559),//switch 2
                CLLocation(latitude: 21.33111458, longitude:72.62580872),//1
                CLLocation(latitude: 28.7040592, longitude:77.1024902),
                CLLocation(latitude: 18.5523254, longitude:73.9015002),
                CLLocation(latitude: 20.593684, longitude:78.96288),
                CLLocation(latitude: 33.778175, longitude:76.5761714),
                CLLocation(latitude: 33.778175, longitude:76.5761714),
                CLLocation(latitude: 28.7040592, longitude:77.1024902),
                CLLocation(latitude: 28.60177, longitude:77.2143393)]
            
            //case 2:
            
        default:
            return []
        }
        
    }
    func getYearsForPersonWithIndex(index: Int) -> [String]{
        
        switch index {
            /*case 0:
             */
        case 1:
            return ["1869","1891","1893","1894","1897","1906","1908","1919","1920","1930","1942","1943","1944","1946","1947","1948","1948"]
            //case 2:
            
        default:
            return []
        }
    }
    
    func getEventsForPersonWithIndex(index: Int) -> [String] {
    
    
    switch index {
    /*case 0:
     */
    case 1:
    return ["Mohandas Karamchand Gandhi was born in Porbandar in West Bengal, India","After attending Inner Temple Law School in the United Kingdom, Gandhi passes the bar exam and becomes a lawyer. Unknown to him at the time, his mother has passed away while he is at school.","Gandhi is thrown off of a train in South Africa for refusing to move from his First Class seat to Third Class (even though he held a valid First Class ticket). Such discrimination against Indians was common practice and this personal experience gives Gandhi resolve to fight racial discrimination.","Gandhi founds the Natal Indian Congress to oppose a bill denying Indians the right to vote in South Africa. Although the bill passes, Gandhi successfully focuses a broad range of public attention on injustices against Indians even as far away as India and the UK.","Landing in Durban Harbor, South Africa, Gandhi is beaten up by a mob of white settlers. His life is saved when the wife of the Durban Police Chief stands between Gandhi and his attackers. Because of media attention to the event, the colonial government is forced to arrest members of the mob but Gandhi refuses to press charges. Gandhi gains increased public admiration and support. His attackers offer a public apology.","The South African colonial government enacts the “Asian Population Registration Act” where all residents of Asian countries, including India, had to register their name, age, address, job, and other personal information and carry a card with their finger prints. Gandhi develops his principals of non-violent protest “satyagraha” (devotion to the truth or “soul force”).","Gandhi and 2,000 fellow Indians in Johannesburg burn their registration cards in protest. Even as Gandhi and other leaders are repeatedly arrested over 6 years of protest, non-violent rallies continue to grow in size.","The British Government passes the Rowlatt Act which gives authority and power to arrest people and keep them in prisons without any trial if they are suspected with the charge of terrorism. It was also the time of the Jallianwala Bagh massacre where a crowd of nonviolent protesters, was fired upon by British troops. The Bagh-space had only five entrances. British troops fired on the crowd for ten minutes, directing their bullets towards the few open gates through which people were trying to flee 379 were killed and 1200 wounded.","Gandhi gets people to more intently boycott British products and encourages people to start making their own clothes rather than buying British clothing. Similar to Gandhi the All-India Congress held a special session at Calcutta on September 4 and agreed to the non-cooperation campaign for independence.","The British retaliate by passing the Salt Act which makes it illegal for Indians to make their own salt, punishable by at least three years in jail. On March 12th, Gandhi (now 61 years old) travels 320 km (200 miles) on foot for 24 days to Dandi to make his own salt. Others follow. Gandhi is again imprisoned.","Gandhi launches the Quit India campaign declaring India’s independence from British rule. Gandhi is imprisoned.","Still in prison the 73 year old Gandhi starts a hunger strike that lasts for 21 days.","Fearful that Gandhi would die in prison due to failing health and become a martyr, he and other leaders are released.","The United Kingdom Cabinet Mission of 1946 to India is created. Its goal was to discuss and plan the transfer of power from the British government to Indian leadership to provide India with independence.","Tensions between Hindu and Muslim factions resurface and escalate into violence. India is divided into Pakistan and India. The lasting effects of the Indo-Pakistani War of 1947 still affects the geopolitics of this region.","Attempting to promote peace and asking that homes be restored to Muslims, payment to Pakistan be made (per an agreement made before the Indo-Pakistani War of 1947), and fighting cease, Gandhi (now 77 years old) starts another fast. Five days into the fast, India makes payment to Pakistan and Hindu, Muslim and Sikh community leaders agree to renounce violence and call for peace.","Mohandas Karamchand Gandhi is killed by a member of a Hindu organization angered by Gandhi’s peacemaking efforts. Gandhi was shot on his way to evening prayers. His memory and teachings live  on in the non-violent peace movements of today."]
    
    // case 2:
    
    default:
    return []
    }
    
    }
    
}
