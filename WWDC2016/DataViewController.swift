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
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    var dataObject: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.clipsToBounds = true
        
        transparentBtn.opaque = true
        transparentBtn.setTitle("", forState: UIControlState.Normal)
        
        //3D touch

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        var descriptiondic: [String:String] = [
            "Albert Einstein" : "Theory of Relativity",
            "Pablo Picasso" : "Painted stuff"
        ]
        
        nameLabel.text = dataObject
        backgroundImage.image = UIImage(named: dataObject+".jpg")
        descLabel.text = descriptiondic[dataObject]
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "gotolocation") {
            let destinationVC = segue.destinationViewController as! LocationViewController
            destinationVC.data = dataObject
        }
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = false
        
    }
    
    @IBAction func onButtonClick(sender: AnyObject) {
        self.performSegueWithIdentifier("gotolocation", sender: nil)
    }
    
    
}

