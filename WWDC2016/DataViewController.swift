//
//  DataViewController.swift
//  WWDC2016
//
//  Created by Philipp Hadjimina on 22/04/16.
//  Copyright © 2016 Philipp Hadjimina. All rights reserved.
//

import UIKit

class DataViewController: UIViewController {
    
    @IBOutlet weak var transparentBtn: UIButton!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    var dataObject: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        transparentBtn.opaque = true
        transparentBtn.setTitle("", forState: UIControlState.Normal)
        
        backgroundImage.clipsToBounds = true;

        if dataObject=="Martin Luther King" {
            nameLabel.font = UIFont(name: "Garamond", size: 40)
        }else if dataObject=="Mahatma Gandhi"{
            nameLabel.font = UIFont(name: "Garamond", size: 45)
        }
        else{
            nameLabel.font = UIFont(name: "Garamond", size: 50)
        }
        


    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //NavBar
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        var People: [String] = ["Albert Einstein","Mahatma Gandhi","Martin Luther King"]
        
        nameLabel.text = dataObject
        backgroundImage.image = UIImage(named: dataObject+".jpg")

        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if (segue.identifier == "gotolocation") {
            let destinationVC = segue.destinationViewController as! LocationViewController
            destinationVC.data = dataObject
            destinationVC.statusStyle = UIStatusBarStyle.Default
        }
        else if (segue.identifier == "gotolocationpeek") {
            let destinationVC = segue.destinationViewController as! LocationViewController
            destinationVC.data = dataObject
            destinationVC.statusStyle = UIStatusBarStyle.LightContent
        }
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = false
        
    }
    
    @IBAction func onButtonClick(sender: AnyObject) {
        print("asdf")
        self.performSegueWithIdentifier("gotolocation", sender: nil)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]){
    
    }
  }

