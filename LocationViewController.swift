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

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    var data:String!
    var locations = [CLLocation(latitude: 21.282778, longitude: -157.829444),
                     CLLocation(latitude: 40.7000, longitude: -120.95000),
                     CLLocation(latitude: 43.25200, longitude: -126.453000),
                     CLLocation(latitude: 83.25200, longitude: -96.453000),
                     CLLocation(latitude: 23.25200, longitude: -146.453000)]
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        //NavBar
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        
        //Table setup
        tableView.decelerationRate = UIScrollViewDecelerationRateFast
        tableView.registerClass(CustomCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.title = data

        //Map setup
        let regionRadius: CLLocationDistance = 1000
        centerMapOnLocation(locations[0],radius: regionRadius)
        
        self.mapView.delegate = self
        
        //Auto-set the UITableViewCells height (requires iOS8+)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 201
    }
    
    func centerMapOnLocation(location: CLLocation, radius: CLLocationDistance) {
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            // do some task
            dispatch_async(dispatch_get_main_queue()) {
                let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,                radius * 2.0, radius * 2.0)
                self.mapView.setRegion(coordinateRegion, animated: true)
            }

        }
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return navigationController?.navigationBarHidden == false
    }

    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    
    
    //MARK: - Tableview Delegate & Datasource
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return locations.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.dateLabel.text = "1996"
        cell.yearLabelLeft = true
        cell.eventDescription.text = String(indexPath.row) + "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus fermentum finibus lorem nec convallis. Proin mattis sapien et maximus tempor. Proin in lacus leo. Mauris pulvinar justo at lacinia eleifend. Vestibulum sed accumsan magna, sed consectetur purus. Maecenas blandit a ante varius facilisis. Morbi pellentesque cursus elit nec congue."
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
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
        centerMapOnLocation(locations[indexPath.row], radius: 1000)
    }
    /*
    - (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    // if decelerating, let scrollViewDidEndDecelerating: handle it
    if (decelerate == NO) {
        [self centerTable];
    }
    }
    
    - (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self centerTable];
    }
    
    - (void)centerTable {
    NSIndexPath *pathForCenterCell = [self.tableView indexPathForRowAtPoint:CGPointMake(CGRectGetMidX(self.tableView.bounds), CGRectGetMidY(self.tableView.bounds))];
    
    [self.tableView scrollToRowAtIndexPath:pathForCenterCell atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
    */
    
}
