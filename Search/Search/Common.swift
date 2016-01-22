//
//  Common.swift
//  Search
//
//  Created by zwy on 16/1/12.
//  Copyright © 2016年 zwyGame. All rights reserved.
//

import UIKit

struct Common{
    static let homeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("homeViewController") as! HomeViewController
    static let collectViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("collectViewController") as! CollectionViewController
    static let matchViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("matchViewController") as! MatchViewController
    
    static let testNavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("testNavigationController")as! UINavigationController
}