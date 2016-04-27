//
//  LocationViewController.swift
//  WWDC2016
//
//  Created by Philipp Hadjimina on 22/04/16.
//  Copyright © 2016 Philipp Hadjimina. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import WatchConnectivity

class LocationViewController: UIViewController,MKMapViewDelegate,UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate,UIGestureRecognizerDelegate {
    
    //Constraints
    @IBOutlet weak var navBarHeight: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet var PanGesturRecognizer: UIPanGestureRecognizer!
    @IBOutlet weak var watchButton: UIBarButtonItem!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var backBtn: UIBarButtonItem!
    var data:String!
    var currentIndex = 0
    var mapFullscreen = false
    var currentLocation :CLLocationCoordinate2D!
    
    @IBOutlet weak var mergerView: UIView!
    @IBOutlet weak var mergerViewHeight: NSLayoutConstraint!
    var currentLocations:[CLLocation]!
    var currentEvents:[String]!
    var currentYears:[String]!
    var currentDescriptions:[String]!
    let defaults = NSUserDefaults.standardUserDefaults()
    var screenWidth:CGFloat!
    let locationManager = CLLocationManager()
    var locationShouldUpdate = false
    var index = 0
    var mergerHeightValue:CGFloat = 368.0
    var bottomOffSet:CGFloat = 0.0
    var topOffSet:CGFloat = 0.0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Geo
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        self.view.sendSubviewToBack(self.mapView)
        
        setNeedsStatusBarAppearanceUpdate()
        
        var fromNotification = false
        //Screen size
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        screenWidth = screenSize.width
        
        //Check Defaults
        if !userAlreadyExist(){
            defaults.setObject("NoOne", forKey: "toBeWatched")
        }
        if !dummynotifcationValueAlreadyExist(){
            defaults.setObject("false", forKey: "dummyNotification")
        }
        
        //Table setup
        tableView.decelerationRate = UIScrollViewDecelerationRateFast
        tableView.registerClass(CustomCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        

        
        
        //Setup for presentation with notification
        if notifcationValueAlreadyExist() && defaults.objectForKey("fromNotification") as! String == "true" {
            data = defaults.objectForKey("toBeWatched") as! String
            setupDataForCorrectPerson()
            
            fromNotification = true
            defaults.setObject("false", forKey: "fromNotification")
            
            if defaults.objectForKey("dummyNotification") as! String == "true" {
                let dummyEntry =  Int(arc4random_uniform(UInt32(currentLocations.count) + 1))
                index = dummyEntry
                centerMapOnLocation(currentLocations[dummyEntry], radius: 1000)
                tableView.scrollToRowAtIndexPath(NSIndexPath(forRow:dummyEntry , inSection: 0), atScrollPosition: .Top, animated: true)
                defaults.setObject("false", forKey: "dummyNotification")
            }
            else{
                locationManager.requestLocation()
            }
            
            
        }else{
            setupDataForCorrectPerson()
        }
        
        
        
        //Set title
        navigationItem.title = data
        
        //Map setup
        let regionRadius: CLLocationDistance = 1000
        
        if !fromNotification && defaults.objectForKey("dummyNotification") as! String != "true"{
            index = 0
            centerMapOnLocation(currentLocations[0],radius: regionRadius)
        }else{
            locationShouldUpdate = true
        }
        
        self.mapView.delegate = self
        
        //Gesture recognizer
        PanGesturRecognizer.delegate = self
        UIView.animateWithDuration(0, animations: {
            //self.tableViewHeight.constant = self.tableHeightValue
            // self.mergerViewHeight.constant = self.tableHeightValue
            self.view.layoutIfNeeded()
        })
        
        
        
        //Setup Orientation
        let orientation: UIDeviceOrientation = UIDevice.currentDevice().orientation
        if orientation.isLandscape {
            getOffsets("loadFromLandscape")
            changeMapView(true)
            setTableBottom()
        }else{
            getOffsets("current")
            setTableFull()
        }
        
        //Setup Annotations
        /*for i in 0..<currentDescriptions.count {
         let artwork = Artwork(title: (navBar.topItem?.title)!+": "+currentYears[i],
         locationName: currentDescriptions[i],
         location: currentLocations[i] )
         mapView.addAnnotation(artwork)
         }*/
        
        var dudeNames = ["Einstein","Gandhi","King"]
        
        for i in 1..<3{
            var tempYear = getYearsForPersonWithIndex(i)
            var tempShort = getAnnotationDescForPersonWithIndex(i)
            var tempLocs = getLocationForPersonWithIndex(i)
            var tempName = dudeNames[i]
            
            for a in 0..<tempLocs.count  {
                let artwork = Artwork(title: tempName+": "+tempYear[a],
                                      locationName: tempShort[a],
                                      location: tempLocs[a])
                mapView.addAnnotation(artwork)
            }
            
        }
        
        
        //Set Correct watchTitle
        if userAlreadyExist() && defaults.stringForKey("toBeWatched") == data
        {
            watchButton.title = "Untrack"
        }
        else{
            watchButton.title = "Track"
        }
        
    }
    
    
    func centerMapOnLocation(location: CLLocation, radius: CLLocationDistance) {
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            // do some task
            dispatch_async(dispatch_get_main_queue()) {
                let modifiedLocation = CLLocation(latitude: location.coordinate.latitude+0.001, longitude: location.coordinate.longitude).coordinate
                let coordinateRegion = MKCoordinateRegionMakeWithDistance(modifiedLocation,radius * 2.0, radius * 2.0)
                self.mapView.setRegion(coordinateRegion, animated: true)
            }
            
        }
        
    }
    
    //Calculate row height based on text
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        var height = currentEvents[indexPath.row].heightWithConstrainedWidth(screenWidth-132, font: UIFont.systemFontOfSize(17, weight: UIFontWeightRegular))
        if height < 175{
            height = 175
        }
        height = height + 75
        return height
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    
    
    //MARK: - Tableview Delegate & Datasource
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return currentLocations.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.dateLabel.text = currentYears[indexPath.row]
        cell.yearLabelLeft = true
        cell.eventDescription.text = currentEvents[indexPath.row]
        return cell
    }
    
    
    
    //Snap scrolling
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate  {
            centerTable()
        }
    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        centerTable()
    }
    
    func centerTable() {
        let center = CGPoint(x: CGRectGetMidX(self.tableView.bounds), y: CGRectGetMidY(self.tableView.bounds))
        let indexPath = tableView.indexPathForRowAtPoint(center)!
        
        tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Middle, animated: true)
        centerMapOnLocation(currentLocations[indexPath.row], radius: 1000)
        index = indexPath.row
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let destinationVC = segue.destinationViewController as! RootViewController
        
        if (segue.identifier == "goback") {
            var indexToSet = 0
            
            if data == "Mahatma Gandhi"{
                indexToSet = 1
            }else if data=="Martin Luther King" {
                indexToSet = 2
            }
            destinationVC.currentIndex = indexToSet
            
            
        }
    }
    
    //Orientation Change
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        switch UIDevice.currentDevice().orientation{
        case .Portrait:
            getOffsets("Portrait")
            setTableFull()
            changeMapView(false)
        case .PortraitUpsideDown:
            getOffsets("Portrait")
            setTableFull()
            changeMapView(false)
        case .LandscapeLeft:
            getOffsets("Landscape")
            setTableBottom()
            changeMapView(true)
        case .LandscapeRight:
            getOffsets("Landscape")
            setTableBottom()
            changeMapView(true)
            
        default:
            break
        }
    }
    
    func changeMapView(fullscreen:Bool){
        
        var constantNav = 0
        var constantTable = 80
        
        self.navBar.hidden = fullscreen
        mapFullscreen = fullscreen
        
        if !fullscreen {
            constantNav = 54
            constantTable = 400
        }
        
        self.view.layoutIfNeeded()
        UIView.animateWithDuration(0.5, animations: {
            self.navBarHeight.constant = CGFloat(constantNav)
            self.view.layoutIfNeeded()
        })
    }
    
    
    //Data Setup
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
            
        case 2:
            return [CLLocation(latitude: 33.748995, longitude: -84.387982),CLLocation(latitude: 38.664512, longitude: -90.333027),CLLocation(latitude: 33.9462125, longitude: -84.3346473),CLLocation(latitude: 39.849557, longitude: -75.355746),CLLocation(latitude: 42.360082, longitude: -71.058880),CLLocation(latitude: 32.634580, longitude: -87.319511),CLLocation(latitude: 36.016829, longitude: -78.901486),CLLocation(latitude: 36.057757, longitude: -78.905451),CLLocation(latitude: 33.756318, longitude: -84.373451),CLLocation(latitude: 33.7556795, longitude: -84.3771254),CLLocation(latitude: 40.712784, longitude: -74.005941),CLLocation(latitude: 20.593684, longitude: 79.1),CLLocation(latitude: 33.7563179, longitude: -84.3734515),CLLocation(latitude: 38.907192, longitude: -77.036871),CLLocation(latitude: 31.870242, longitude: -116.638977),CLLocation(latitude: 32.407359, longitude: -87.021101),CLLocation(latitude: 41.878114, longitude: -87.629798),CLLocation(latitude: 38.907191, longitude: -77.036870),CLLocation(latitude: 35.149534, longitude: -90.048980)]
            
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
            
        case 2:
            return ["Michael King, later known as Martin Luther King, Jr., is born at 501 Auburn Ave. in Atlanta, Georgia.","King begins his freshman year at Morehouse College in Atlanta.","The Atlanta Constitution publishes King’s letter to the editor stating that black people \"are entitled to the basic rights and opportunities of American citizens.\"","King is ordained and appointed assistant pastor at Ebenezer Baptist Church in Atlanta receives his bachelor of arts degree in sociology from Morehouse College and begins his at Crozer Theological Seminary in Chester, Pennsylvania.","Marries New England Conservatory music student Coretta Scott; they eventually have four children.","King and Coretta Scott are married at the Scott home near Marion, Alabama.","King begins his pastorate at Dexter Avenue Baptist Church in Montgomery, Alabama.","King is awarded his doctorate in systematic theology from Boston University and his first child is born. Rosa Parks is arrested for refusing to vacate her seat and move to the rear of a city bus in Montgomery to make way for a white passenger. Jo Ann Robinson and other Women’s Political Council members mimeograph thousands of leaflets calling for a one-day boycott of the city’s buses on Monday, 5 December. At a mass meeting at Holt Street Baptist Church, the Montgomery Improvement Association(MIA) is formed. King becomes its president.","While King speaks at a mass meeting, his home is bombed. His wife and daughter are not injured. Later King addresses an angry crowd that gathers outside the house, pleading for nonviolence. Montgomery City Lines resumes full service on all routes. King is among the first passengers to ride the buses in an integrated fashion.","King helps found Southern Christian Leadership Conference (SCLC).","Writes Stride Toward Freedom, about the bus boycott. It gets published by Harper & Brothers, whose headquarters are located in","Visits India to study nonviolence and civil disobedience.","Joins his father as co-pastor of Ebenezer Baptist Church in Atlanta.","King is arrested and jailed during anti-segregation protests in Birmingham; writes Letter From Birmingham City Jail, arguing that individuals have the moral duty to disobey unjust laws. Delivers \"I Have a Dream\" speech during the March on Washington attended by 200,000 protesters, creates powerful image, builds momentum for civil rights legislation.","Publishes Why We Can't Wait. Congress passes Civil Rights Act of 1964, outlawing segregation in public accommodations and discrimination in education and employment. King receives Nobel Peace Prize the  in auditorium of the University of Oslo.","King and SCLC join voting-rights march from Selma to Montgomery; police beat and tear gas marchers; King addresses rally before state capitol, builds support for voting rights. Congress passes Voting Rights Act of 1965, which suspends literacy tests and other restrictions to prevent blacks from voting.","Growing popularity of the black power movement, blacks stressing self-reliance and self-defense, indicates King's influence was declining, especially among young blacks. King turns toward economic issues; SCLC moves civil rights struggle to the North; opens Chicago office to organize protests against housing and employment discrimination.","King plans Poor People's Campaign which later took place in Washington DC advocates redistribution of wealth to eradicate black poverty. Publishes Where Do We Go from Here: Chaos or Community?","King is assassinated in Memphis, during visit to support striking black garbage collectors; violent riots erupt in more than 100 U.S. cities."]
            
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
            
        case 2:
            return ["1929","1944","1946","1948","1951","1953","1954","1955","1956","1957","1958","1959","1960","1963","1964","1965","1966","1967","1968"]
            
        default:
            return []
        }
    }
    
    func getAnnotationDescForPersonWithIndex(index: Int) -> [String] {
        switch index {
        case 1:
            return ["Gandhis Brithplace","Graduation from Inner Temple Law School","Thrown off of train due to discrimination","Natal Indian Congress is founded","Attack by angry mob","Mass meetings outside the Hamidia Mosque","Burning of registration cards as protest","Jallianwala Bagh massacre","Boycott of british goods","Gandhi arrested for producing salt","Gandhis Quit India speech","Beginning 21 day hunger strike in Delhi","Release of prisoners","First steps to Indian Indepen independence","War over Kashmir and Jammu","Start of another hunger strike (probably in Delhi) in order to achieve peace","Assassination at Birla House (now Gandhi Smriti)"]
        case 2:
            return ["Martin Luther King is born","Beginning of Studies at Morehouse","HQ of The Atlanta Journal-Constitution","Becomes Pastor and receivs bechelors degree","Beginning of Studies in Boston","Marriage","Beginning of Pastorate","Becomes President of the MIA","Bombing of Kings home","Nationonal Office of the SCLC","Stride Toward Freedom","Visit to India","Co-pastor in Ebenzer","March on Washington","Receives Nobel Peace Prize","Voting-rights march","Opens chicago office","Planing of Poor People's Campaign","Assassination"]
        default:
            return []
        }
    }
    
    
    //Map Pins with Annotatios
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? Artwork {
            let identifier = "pin"
            
            var view: MKPinAnnotationView
            /*if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
             as? MKPinAnnotationView { // 2
             dequeuedView.annotation = annotation
             view = dequeuedView
             } else {*/
            // 3
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type:.InfoLight) as UIView
            
            //Tint color workaround
            let fullNameArr = annotation.title!.characters.split{$0 == ":"}.map(String.init)
            if fullNameArr[0] == "Gandhi"{
                view.pinTintColor = UIColor.blueColor()
            }else if fullNameArr[0] == "King"{
                view.pinTintColor = UIColor.greenColor()
            }
            else{
                view.pinTintColor = UIColor.redColor()
            }
            // }
            return view
        }
        return nil
    }
    
    
    //Geo
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        mapView.showsUserLocation = (status == .AuthorizedAlways)
    }
    
    func regionFromCLLocation(location: CLLocation,year : String) -> CLCircularRegion {
        
        let region = CLCircularRegion(center: location.coordinate, radius: 6000, identifier: year+data)
        region.notifyOnEntry = true
        return region
    }
    
    func startMonitoringLocation() {
        stopMonitoringLocations(locationManager,defaults: defaults)
        for i in 0..<currentLocations.count {
            if !CLLocationManager.isMonitoringAvailableForClass(CLCircularRegion) {
                showSimpleAlertWithTitle("Error", message: "Geofencing is not supported on this device!", viewController: self)
                return
            }
            if CLLocationManager.authorizationStatus() != .AuthorizedAlways {
                showSimpleAlertWithTitle("Warning", message: "Your geotification is saved but will only be activated once you grant Geotify permission to access the device location.", viewController: self)
            }
            let region = regionFromCLLocation(currentLocations[i], year: currentYears[i])
            locationManager.startMonitoringForRegion(region)
        }
    }
    
    @IBAction func didClickWatch(sender: AnyObject) {
        trackerHandler()
        
    }
    
    func trackerHandler()  {
        if defaults.stringForKey("toBeWatched") == data {
            watchButton.title = "Track"
            stopMonitoringLocations(locationManager,defaults: defaults)
            
            defaults.setObject("NoOne", forKey: "toBeWatched")
        }
        else{
            startMonitoringLocation()
            
            defaults.setObject(data, forKey: "toBeWatched")
            alertLogic()
            
        }
        let dummy = ["toBeWatched" : defaults.objectForKey("toBeWatched") as AnyObject!]
        
        WCSession.defaultSession().transferUserInfo(dummy)
    }
    
    //Show alert
    func alertLogic()  {
        let alertController = UIAlertController(title: "Location Trigger", message: "In order for you to be able to test the location service you can now choose if the app should simply trigger a  dummy notification (in 10 seconds) or if you want to enable the actual geofenceing", preferredStyle: .Alert)
        
        alertController.view.tintColor = UIColor.blackColor()
        // Create the actions
        let okAction = UIAlertAction(title: "Geofencing", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            
            self.startMonitoringLocation()
            self.watchButton.title = "Untrack"
            self.defaults.setObject(self.data, forKey: "toBeWatched")
        }
        
        let dummy = UIAlertAction(title: "Dummy", style: UIAlertActionStyle.Default) {
            
            UIAlertAction in
            //Schedule dummy notification
            let notification = UILocalNotification()
            notification.fireDate = NSDate(timeIntervalSinceNow: 10)
            notification.alertTitle = "Encounter"
            notification.alertBody = notefromRegionIdentifier(self.defaults.stringForKey("toBeWatched")!)
            notification.soundName = UILocalNotificationDefaultSoundName
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
            
            self.defaults.setObject("true", forKey: "dummyNotification")
            self.defaults.setObject(self.data, forKey: "toBeWatched")
            
            self.watchButton.title = "Untrack"
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
        }
        
        // Add the actions
        alertController.addAction(dummy)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.presentViewController(alertController, animated: true, completion: nil)
        
        
    }
    
    
    func locationManager(manager: CLLocationManager, monitoringDidFailForRegion region: CLRegion?, withError error: NSError) {
        print("Monitoring failed for region with identifier: \(region!.identifier)")
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Location Manager failed with the following error: \(error)")
    }
    
    func userAlreadyExist() -> Bool {
        if (defaults.stringForKey("toBeWatched") != nil) {
            return true
        }
        return false
    }
    
    func notifcationValueAlreadyExist() -> Bool {
        if (defaults.stringForKey("fromNotification") != nil) {
            return true
        }
        return false
    }
    
    func dummynotifcationValueAlreadyExist() -> Bool {
        if (defaults.stringForKey("dummyNotification") != nil) {
            return true
        }
        return false
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locationShouldUpdate {
            currentLocation = locationManager.location!.coordinate
            let row = getNearestLocationIndex()
            
            tableView.scrollToRowAtIndexPath(NSIndexPath(forRow:row , inSection: 0), atScrollPosition: .Top, animated: true)
            let regionRadius: CLLocationDistance = 1000
            centerMapOnLocation(currentLocations[row],radius: regionRadius)
            index = row
            
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        print("change")
        return UIStatusBarStyle.Default
    }
    
    func getNearestLocationIndex() -> Int {
        
        var minDistanceIndex = 0
        
        let getLat: CLLocationDegrees = currentLocation.latitude
        let getLon: CLLocationDegrees = currentLocation.longitude
        let mapLocationCL:CLLocation = CLLocation(latitude: getLat, longitude: getLon)
        
        if currentLocations.count != 0 {
            
            var minDistance = mapLocationCL.distanceFromLocation(currentLocations[0])
            
            for i in 1..<currentLocations.count {
                let distance = mapLocationCL.distanceFromLocation(currentLocations[i])
                if distance < minDistance {
                    minDistance = distance
                    minDistanceIndex = i
                }
            }
            
        }
        
        return minDistanceIndex
    }
    
    func setupDataForCorrectPerson()  {
        
        //Setup NavBar Text
        let fullNameArr = data.characters.split{$0 == " "}.map(String.init)
        navBar.topItem?.title = fullNameArr[fullNameArr.count-1]+"'s Journey"
        if fullNameArr[fullNameArr.count-1] == "Gandhi"{
            currentIndex = 1
        }else if fullNameArr[fullNameArr.count-1] == "King"{
            currentIndex = 2
        }
        
        //get Data
        currentLocations = getLocationForPersonWithIndex(currentIndex)
        currentYears = getYearsForPersonWithIndex(currentIndex)
        currentEvents = getEventsForPersonWithIndex(currentIndex)
        currentDescriptions = getAnnotationDescForPersonWithIndex(currentIndex)
    }
    
    
    
    
    //preview Actions
    override func previewActionItems() -> [UIPreviewActionItem] {
        
        
        if watchButton.title == "Untrack" {
            //Actual Geofencing
            let geo = UIPreviewAction(title: watchButton.title!, style: .Default) { (action, viewController) -> Void in
                self.trackerHandler()
            }
            return [geo]
        }
        else{
            //Actual Geofencing
            let geo = UIPreviewAction(title: watchButton.title!, style: .Default) { (action, viewController) -> Void in
                self.trackerHandler()
            }
            
            //Dummy notification
            let dummy = UIPreviewAction(title: watchButton.title!, style: .Default) { (action, viewController) -> Void in
                self.defaults.setObject(self.data, forKey: "toBeWatched")
                //Schedule dummy notification
                let notification = UILocalNotification()
                notification.fireDate = NSDate(timeIntervalSinceNow: 10)
                notification.alertTitle = "Encounter"
                notification.alertBody = notefromRegionIdentifier(self.defaults.stringForKey("toBeWatched")!)
                notification.soundName = UILocalNotificationDefaultSoundName
                UIApplication.sharedApplication().scheduleLocalNotification(notification)
                
                self.defaults.setObject("true", forKey: "dummyNotification")
                self.defaults.setObject(self.data, forKey: "toBeWatched")
                
                self.watchButton.title = "Untrack"
                
            }
            return [geo,dummy]
        }
    }
    
    
    //Pan gesture
    @IBAction func dragTable(sender: UIPanGestureRecognizer)
    {
        let translation = sender.translationInView(self.view)

        self.mergerHeightValue = self.mergerView.frame.size.height - translation.y
        
        
        print("height "+String(self.mergerView.frame.size.height))
        print("bottom "+String(self.bottomOffSet))
        print("top "+String(self.topOffSet))
        
        if self.mergerHeightValue > bottomOffSet && self.mergerHeightValue < topOffSet  {
            
            
        sender.view!.center = CGPoint(x: sender.view!.center.x, y: sender.view!.center.y + translation.y)
        sender.setTranslation(CGPointZero, inView: self.view)
        
        self.view.layoutIfNeeded()
        UIView.animateWithDuration(0, animations: {
           // self.tableViewHeight.constant = self.tableHeightValue
            
            self.mergerViewHeight.constant = self.mergerHeightValue
            self.view.layoutIfNeeded()
        })
       }

 }
    func getOffsets(type: String) {
        
        let bounds = UIScreen.mainScreen().bounds
        let height = bounds.size.height
        let width = bounds.size.width
        
        if type == "Landscape" {
            bottomOffSet = 50.0
            topOffSet = width - 200.0
        }
        else if type == "Portrait"{
            topOffSet = width - 350.0
            bottomOffSet = 46.0
        }else if type=="loadFromLandscape"{
            topOffSet = height - 200.0
            bottomOffSet = 50.0
    }else{
            let orientation = UIDevice.currentDevice().orientation
            if orientation.isLandscape{
                bottomOffSet = 50.0
                topOffSet = width - 200.0
            }else{
                topOffSet = height - 350.0
                bottomOffSet = 46.0
            }
        }
    }
    
    func setTableBottom()  {
        self.view.layoutIfNeeded()
        UIView.animateWithDuration(0.5, animations: {
        
            self.mergerViewHeight.constant = self.bottomOffSet
            self.view.layoutIfNeeded()
        })
    }

    
    func setTableFull()  {
        self.view.layoutIfNeeded()
        UIView.animateWithDuration(0.5, animations: {
            
            self.mergerViewHeight.constant = self.topOffSet
            self.view.layoutIfNeeded()
        })

    }

}


//Get height for string
extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.max)
        
        let boundingBox = self.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
}
