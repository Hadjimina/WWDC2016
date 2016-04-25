//
//  DataViewController.swift
//  WWDC2016
//
//  Created by Philipp Hadjimina on 22/04/16.
//  Copyright © 2016 Philipp Hadjimina. All rights reserved.
//

import UIKit

class DataViewController: UIViewController {
    
    @IBOutlet weak var backImgBottom: NSLayoutConstraint!
    @IBOutlet weak var backImgRight: NSLayoutConstraint!
    @IBOutlet weak var backImgLeft: NSLayoutConstraint!
    @IBOutlet weak var backImgTop: NSLayoutConstraint!
    
    @IBOutlet weak var transparentBtn: UIButton!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    var dataObject: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        transparentBtn.opaque = true
        transparentBtn.setTitle("", forState: UIControlState.Normal)
        self.view.backgroundColor = UIColor.blackColor()
        backgroundImage.clipsToBounds = true;
        
        if dataObject=="Martin Luther King" {
            nameLabel.font = UIFont(name: "Garamond", size: 40)
        }else if dataObject=="Mahatma Gandhi"{
            nameLabel.font = UIFont(name: "Garamond", size: 45)
        }
        else{
            nameLabel.font = UIFont(name: "Garamond", size: 50)
        }
        
        
        self.addParallaxToView(self.backgroundImage)
    }
    
    override func viewDidAppear(animated: Bool) {
        print("appeared")
        
      
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.backgroundImage.hidden = false
        //NavBar
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        var People: [String] = ["Albert Einstein","Mahatma Gandhi","Martin Luther King"]
        
        nameLabel.text = dataObject
        backgroundImage.image = UIImage(named: dataObject+".jpg")
        
        self.view.layoutIfNeeded()
        UIView.animateWithDuration(1, animations: {
            self.backImgTop.constant = -30
            self.view.layoutIfNeeded()
        })
        
        UIView.animateWithDuration(1, animations: {
            self.backImgLeft.constant = -50
            self.view.layoutIfNeeded()
        })
        
        UIView.animateWithDuration(1, animations: {
            self.backImgRight.constant = -50
            self.view.layoutIfNeeded()
        })
        
        UIView.animateWithDuration(1, animations: {
            self.backImgBottom.constant = -30
            self.view.layoutIfNeeded()
        })

    }
    
    override func viewDidDisappear(animated: Bool) {


        
                print("did dis "+dataObject)
        //self.backgroundImage.hidden = true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if (segue.identifier == "gotolocation") {
            let destinationVC = segue.destinationViewController as! LocationViewController
            destinationVC.data = dataObject
            UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        
        }
        else if (segue.identifier == "gotolocationpeek") {
            let destinationVC = segue.destinationViewController as! LocationViewController
            destinationVC.data = dataObject
        }
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = false
        
        UIView.animateWithDuration(0.75, animations: {
            self.backImgTop.constant = -20
            self.view.layoutIfNeeded()
        })
        
        UIView.animateWithDuration(0.75, animations: {
            self.backImgLeft.constant = -5
            self.view.layoutIfNeeded()
        })
        
        UIView.animateWithDuration(0.75, animations: {
            self.backImgRight.constant = -40
            self.view.layoutIfNeeded()
        })
        
        UIView.animateWithDuration(0.75, animations: {
            self.backImgBottom.constant = -20
            self.view.layoutIfNeeded()
        })
 
        

    }
    
    @IBAction func onButtonClick(sender: AnyObject) {
        print("asdf")
        self.performSegueWithIdentifier("gotolocation", sender: nil)
    }
    
    func addParallaxToView(vw: UIView) {
        let amount = 25
        
        let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .TiltAlongHorizontalAxis)
        horizontal.minimumRelativeValue = -amount
        horizontal.maximumRelativeValue = amount
        
        let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .TiltAlongVerticalAxis)
        vertical.minimumRelativeValue = -amount
        vertical.maximumRelativeValue = amount
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontal, vertical]
        vw.addMotionEffect(group)
        

    }
}
