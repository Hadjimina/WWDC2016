//
//  CustomCell.swift
//  WWDC2016
//
//  Created by Philipp Hadjimina on 22/04/16.
//  Copyright © 2016 Philipp Hadjimina. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    let dateLabel = UILabel()
    var verticalLine = UIImageView()
    var dot = UIImageView()
    var yearLabelLeft = Bool()
    let eventDescription = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        super.awakeFromNib()
        
        //Setup
        dot = UIImageView(image: UIImage(named:"dot.png"))
        verticalLine = UIImageView(image: UIImage(named:"dot.png"))
        eventDescription.numberOfLines = 10
        
        dot.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        verticalLine.translatesAutoresizingMaskIntoConstraints = false
        eventDescription.translatesAutoresizingMaskIntoConstraints = false
        
        dateLabel.font = UIFont(name: "GillSans", size: 17)
        eventDescription.font = UIFont(name: "GillSans-Light", size: 17)
        
        contentView.addSubview(dot)
        contentView.addSubview(dateLabel)
        contentView.addSubview(verticalLine)
        contentView.addSubview(eventDescription)
        
        let viewsDict = [
            "dot" : dot,
            "line" : verticalLine,
            "text" : eventDescription,
            "date" : dateLabel,
            ]

        

            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[date(40)]-80-[text]-|", options: [], metrics: nil, views: viewsDict))
          contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-68-[dot(5)]", options: [], metrics: nil, views: viewsDict))
                    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-70-[line(1)]", options: [], metrics: nil, views: viewsDict))
        
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[date(14)]", options: [], metrics: nil, views: viewsDict))
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[line]|", options: [], metrics: nil, views: viewsDict))
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-16-[dot(5)]", options: [], metrics: nil, views: viewsDict))
                                    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[text(>=175)]-|", options: [], metrics: nil, views: viewsDict))

            
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
