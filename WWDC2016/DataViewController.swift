//
//  DataViewController.swift
//  WWDC2016
//
//  Created by Philipp Hadjimina on 22/04/16.
//  Copyright © 2016 Philipp Hadjimina. All rights reserved.
//

import UIKit

class DataViewController: UIViewController,UIViewControllerPreviewingDelegate {
    
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
                print("did load appeared")
        
        self.addParallaxToView(self.backgroundImage)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewDidAppear(animated: Bool) {
        setNeedsStatusBarAppearanceUpdate()
        if traitCollection.forceTouchCapability == .Available {
            self.registerForPreviewingWithDelegate(self, sourceView: transparentBtn)
        }
        
        print("didappeared")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        self.backgroundImage.hidden = false
        
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
            self.backImgBottom.constant = -50
            self.view.layoutIfNeeded()
        })
        


    }


    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if (segue.identifier == "gotolocation") {
            let destinationVC = segue.destinationViewController as! LocationViewController
            destinationVC.data = dataObject

            //UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        
        }
        else if (segue.identifier == "gotolocationpeek") {
            let destinationVC = segue.destinationViewController as! LocationViewController
            destinationVC.data = dataObject
            //UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
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
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        return UIStatusBarStyle.LightContent
    }
    
    @IBAction func onButtonClick(sender: AnyObject) {
 
        //self.performSegueWithIdentifier("notificationLoad", sender: nil)
    }
    
    func addParallaxToView(vw: UIView) {
        let amount = 15
        
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
    
    //Preview Actions
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let detailVC = storyboard?.instantiateViewControllerWithIdentifier("location") as? LocationViewController else { return nil }
        
        detailVC.data = dataObject
        
        
        return detailVC
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        
        showViewController(viewControllerToCommit, sender: self)
        
    }
    

    
}

