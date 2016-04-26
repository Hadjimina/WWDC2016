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
    let eventDescription = TopAlignedLabel()
    let dummySpacer = UIView()
    
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
        eventDescription.numberOfLines = 0
        
        dot.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        verticalLine.translatesAutoresizingMaskIntoConstraints = false
        eventDescription.translatesAutoresizingMaskIntoConstraints = false
        
        
        dateLabel.font =  UIFont.systemFontOfSize(17, weight: UIFontWeightLight)
        eventDescription.font = UIFont.systemFontOfSize(17, weight: UIFontWeightRegular)
        
        contentView.addSubview(dummySpacer)
        contentView.addSubview(dot)
        contentView.addSubview(dateLabel)
        contentView.addSubview(verticalLine)
        contentView.addSubview(eventDescription)
        
        let viewsDict = [
            "dot" : dot,
            "line" : verticalLine,
            "text" : eventDescription,
            "date" : dateLabel,
            "spacer": dummySpacer
        ]
        eventDescription.sizeToFit()
        
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[date(40)]-60-[text]-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-68-[dot(5)]", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-70-[line(1)]", options: [], metrics: nil, views: viewsDict))
        
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-36-[date(14)]", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[line]|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-40-[dot(5)]", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-36-[text]-|", options: [], metrics: nil, views: viewsDict))
        
        
        
        
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    /*
     - (void)alignTop{
     CGSize fontSize = [self.text sizeWithAttributes:@{NSFontAttributeName:self.font}];
     double finalHeight = fontSize.height * self.numberOfLines;
     double finalWidth = self.frame.size.width;    //expected width of label
     CGRect rect = [self.text boundingRectWithSize:CGSizeMake(finalWidth, finalHeight) options:NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:self.font} context:nil];
     CGSize theStringSize = rect.size;
     int newLinesToPad = (finalHeight  - theStringSize.height) / fontSize.height;
     for(int i=0; i< newLinesToPad; i++)
     self.text = [self.text stringByAppendingString:@" \n"];
     }*/
    
    func alignTop() {
        
    }
    
    
}
