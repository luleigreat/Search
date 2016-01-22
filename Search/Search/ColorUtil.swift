//
//  ColorUtil.swift
//  Search
//
//  Created by zwy on 16/1/13.
//  Copyright © 2016年 zwyGame. All rights reserved.
//

import UIKit

extension String{
    func subString(index: Int)->String{
        let startIndex = self.startIndex.advancedBy(index)
        return self.substringFromIndex(startIndex)
    }
}
struct ColorUtil{
    //static let mainPageBack =
    
    static func UIColorFromRGB(colorCode:String,alpha:Float=1.0)->UIColor{
        let scanner = NSScanner(string: colorCode)
        var color:UInt32 = 0
        scanner.scanHexInt(&color)
        
        let mask = 0x000000FF
        let r = CGFloat(Float(Int(color >> 16) & mask) / 255.0)
        let g = CGFloat(Float(Int(color >> 8) & mask)/255.0)
        let b = CGFloat(Float(Int(color) & mask)/255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: CGFloat(alpha))
    }
}