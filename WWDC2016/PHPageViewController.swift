//
//  PHPageViewController.swift
//  WWDC2016
//
//  Created by Philipp Hadjimina on 22/04/16.
//  Copyright © 2016 Philipp Hadjimina. All rights reserved.
//

import UIKit

class PHPageViewController: UIPageViewController {

override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    let subViews: NSArray = view.subviews
    var scrollView: UIScrollView? = nil
    var pageControl: UIPageControl? = nil
    
    for view in subViews {
        if view.isKindOfClass(UIScrollView) {
            scrollView = view as? UIScrollView
        }
        else if view.isKindOfClass(UIPageControl) {
            pageControl = view as? UIPageControl
        }
    }
    
    if (scrollView != nil && pageControl != nil) {
        scrollView?.frame = view.bounds
        view.bringSubviewToFront(pageControl!)
    }
}
}