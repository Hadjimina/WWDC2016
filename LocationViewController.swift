//
//  LocationViewController.swift
//  WWDC2016
//
//  Created by Philipp Hadjimina on 22/04/16.
//  Copyright © 2016 Philipp Hadjimina. All rights reserved.
//

import UIKit
import MapKit

class LocationViewController: UIViewController,MKMapViewDelegate,UITableViewDataSource,UITableViewDelegate {

    //Constraints
    @IBOutlet weak var navBarHeight: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var backBtn: UIBarButtonItem!
    var data:String!
    var statusStyle:UIStatusBarStyle!
    
    var mapFullscreen = false

    var currentLocations:[CLLocation]!
    var currentEvents:[String]!
    var currentYears:[String]!
    var currentDescriptions:[String]!
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var currentIndex = 0
        
        //Setup NavBar Text
        let fullNameArr = data.characters.split{$0 == " "}.map(String.init)
        navBar.topItem?.title = fullNameArr[fullNameArr.count-1]+"'s Journey"
        self.navBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navBar.shadowImage = UIImage()
        self.navBar.translucent = true

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
        
        //Status Bar
        UIApplication.sharedApplication().statusBarStyle = statusStyle
        
        //Table setup
        tableView.decelerationRate = UIScrollViewDecelerationRateFast
        tableView.registerClass(CustomCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.title = data

        print(currentLocations.count)
        print(currentEvents.count)
        print(currentYears.count)
        //Map setup
        let regionRadius: CLLocationDistance = 1000
        centerMapOnLocation(currentLocations[0],radius: regionRadius)
        self.mapView.delegate = self
        
        //Auto-set the UITableViewCells height (requires iOS8+)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 250
        
        //Add touchevent to map
        /*let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(LocationViewController.mapTapped))
        mapView.userInteractionEnabled = true
        mapView.addGestureRecognizer(tapGestureRecognizer)*/
        
        //Setup Orientation
        let orientation: UIDeviceOrientation = UIDevice.currentDevice().orientation
        if orientation.isLandscape {
            changeMapView(true)
        }
        
        
        //Setup Annotations
        for i in 0..<currentDescriptions.count {
            let artwork = Artwork(title: currentYears[i],
                                  locationName: currentDescriptions[i],
                                  location: currentLocations[i] )
            mapView.addAnnotation(artwork)
        }

        
        
        
    }
    
    func centerMapOnLocation(location: CLLocation, radius: CLLocationDistance) {
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            // do some task
            dispatch_async(dispatch_get_main_queue()) {
                let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,radius * 2.0, radius * 2.0)
                self.mapView.setRegion(coordinateRegion, animated: true)
            }

        }

    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
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
    }

    @IBAction func onBackClick(sender: AnyObject) {
        self.performSegueWithIdentifier("goback", sender: nil)
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
            changeMapView(false)
        case .PortraitUpsideDown:
            changeMapView(false)
        case .LandscapeLeft:
            changeMapView(true)
        case .LandscapeRight:
            changeMapView(true)
        default:
            break
        }
    }

    func changeMapView(fullscreen:Bool){
        
        var constantNav = 0
        var constantTable = 0
        
        mapFullscreen = fullscreen
        
        if !fullscreen {
            constantNav = 54
            constantTable = 400
        }

        UIView.animateWithDuration(0.5,delay: 0, options: UIViewAnimationOptions.TransitionCrossDissolve,    animations: { () -> Void in
                                    self.tableViewHeight.constant = CGFloat(constantTable)
            },completion: nil)
        UIView.animateWithDuration(0.5,delay: 0, options: UIViewAnimationOptions.TransitionCrossDissolve,    animations: { () -> Void in
             self.navBarHeight.constant = CGFloat(constantNav)
            },completion: nil)
    }
    
    func mapTapped()
    {
        let orientation: UIDeviceOrientation = UIDevice.currentDevice().orientation
        if !orientation.isLandscape {
            if mapFullscreen {
                changeMapView(false)
            }
            else{
                changeMapView(true)
            }
        }
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
            return ["Mohandas Karamchand Gandhi was born in Porbandar in West Bengal, India","After attending Inner Temple Law School in the United Kingdom, Gandhi passes the bar exam and becomes a lawyer. Unknown to him at the time, his mother has passed away while he is at school.","Gandhi is thrown off of a train in South Africa for refusing to move from his First Class seat to Third Class (even though he held a valid First Class ticket). Such discrimination against Indians was common practice and this personal experience gives Gandhi resolve to fight racial discrimination.","Gandhi founds the Natal Indian Congress to oppose a bill denying Indians the right to vote in South Africa. Although the bill passes, Gandhi successfully focuses a broad range of public attention on injustices against Indians even as far away as India and the UK.","Landing in Durban Harbor, South Africa, Gandhi is beaten up by a mob of white settlers. His life is saved when the wife of the Durban Police Chief stands between Gandhi and his attackers. Because of media attention to the event, the colonial government is forced to arrest members of the mob but Gandhi refuses to press charges. Gandhi gains increased public admiration and support. His attackers offer a public apology.","The South African colonial government enacts the “Asian Population Registration Act” where all residents of Asian countries, including India, had to register their name, age, address, job, and other personal information and carry a card with their finger prints. Gandhi develops his principals of non-violent protest “satyagraha” (devotion to the truth or “soul force”).","Gandhi and 2,000 fellow Indians in Johannesburg burn their registration cards in protest. Even as Gandhi and other leaders are repeatedly arrested over 6 years of protest, non-violent rallies continue to grow in size.","The British Government passes the Rowlatt Act which gives authority and power to arrest people and keep them in prisons without any trial if they are suspected with the charge of terrorism. The Indian National Congress starts the Hartal Movement where thousands of Indians stop working and stop selling and buying British goods in protest. It was also the time of the Jallianwala Bagh massacre where a crowd of nonviolent protesters, was fired upon by troops of the British Indian Army under the command of Colonel Reginald Dyer The Bagh-space comprised 28,000 m2 (6 to 7 acres) and was walled on all sides with five entrances. On Dyer's orders, his troops fired on the crowd for ten minutes, directing their bullets largely towards the few open gates through which people were trying to flee. The British government released figures stating 379 dead and 1200 wounded.","Gandhi gets people to more intently boycott British products and encourages people to start making their own clothes rather than buying British clothing. Similar to Gandhi the All-India Congress held a special session at Calcutta on September 4 and agreed to the non-cooperation campaign for independence.","The British retaliate by passing the Salt Act which makes it illegal for Indians to make their own salt, punishable by at least three years in jail. On March 12th, Gandhi (now 61 years old) travels 320 km (200 miles) on foot for 24 days to Dandi to make his own salt. Others follow. Gandhi is again imprisoned.","Gandhi launches the Quit India campaign declaring India’s independence from British rule. Gandhi is imprisoned.","Still in prison the 73 year old Gandhi starts a hunger strike that lasts for 21 days.","Fearful that Gandhi would die in prison due to failing health and become a martyr, he and other leaders are released.","The United Kingdom Cabinet Mission of 1946 to India is created. Its goal was to discuss and plan the transfer of power from the British government to Indian leadership to provide India with independence.","Tensions between Hindu and Muslim factions resurface and escalate into violence. India is divided into Pakistan and India. The lasting effects of the Indo-Pakistani War of 1947 still affects the geopolitics of this region.","Attempting to promote peace and asking that homes be restored to Muslims, payment to Pakistan be made (per an agreement made before the Indo-Pakistani War of 1947), and fighting cease, Gandhi (now 77 years old) starts another fast. Five days into the fast, India makes payment to Pakistan and Hindu, Muslim and Sikh community leaders agree to renounce violence and call for peace.","Mohandas Karamchand Gandhi is killed by a member of a Hindu organization angered by Gandhi’s peacemaking efforts. Gandhi was shot on his way to evening prayers. His memory and teachings live  on in the non-violent peace movements of today."]
            
       // case 2:
            
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
    
    func getAnnotationDescForPersonWithIndex(index: Int) -> [String] {
        switch index {
        case 1:
            return ["Gandhis Brithplace","Graduation from Inner Temple Law School","Thrown off of train due to discrimination","Natal Indian Congress is founded","Attack by angry mob","Mass meetings outside the Hamidia Mosque","Burning of registration cards as protest","Jallianwala Bagh massacre","Boycott of british goods","Gandhi arrested for producing salt","Gandhis Quit India speech","Beginning 21 day hunger strike in Delhi","Release of prisoners","First steps to Indian Indepen independence","War over Kashmir and Jammu","Start of another hunger strike (probably in Delhi) in order to achieve peace","Assassination at Birla House (now Gandhi Smriti)"]
        default:
            return []
        }
    }
    
    //Map Pins with Annotatios
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? Artwork {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? MKPinAnnotationView { // 2
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                // 3
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type:.System) as UIView
            }
            return view
        }
        return nil
    }
}
