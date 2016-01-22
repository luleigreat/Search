//
//  DropView.swift
//  Search
//
//  Created by zwy on 16/1/15.
//  Copyright © 2016年 zwyGame. All rights reserved.
//

import UIKit

class DropView: UIControl {
    var text=""{
        didSet{
            setNeedsLayout()
        }
    }
    var originColor:UIColor?
    
    var mLabel:UILabel?
    var mImage:UIImageView?
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        /*
        let labelFrame = CGRectMake(0, 0, frame.width-15, frame.height)
        mLabel?.frame = labelFrame
        let imgFrame = CGRectMake(frame.width-15, (frame.height - 15)/2, 15, 15)
        */
        let labelFrame = CGRectMake(0, 7, frame.width, frame.height - 15)
        mLabel?.frame = labelFrame
        let imgFrame = CGRectMake(frame.width/2 - 6, frame.height - 12, 12, 12)
        
        mLabel = UILabel(frame:labelFrame)
        mImage = UIImageView(frame:imgFrame)
        mImage?.image = UIImage(named: "down_dark")
        
        mLabel?.textColor = ColorUtil.UIColorFromRGB("000000")
        mLabel?.font = UIFont.systemFontOfSize(20)
        mLabel?.textAlignment = .Center
        
        addSubview(mLabel!)
        addSubview(mImage!)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.userInteractionEnabled = true
    }
    
    override func layoutSubviews() {
        mLabel?.text = text
    }
    /*
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        originColor = self.backgroundColor
        self.backgroundColor = UIColor.grayColor()
        return true
    }
    
    override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        return true
    }
    
    override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        self.backgroundColor = originColor
    }*/
}
