//
//  LeftViewController.swift
//  Search
//
//  Created by zwy on 16/1/11.
//  Copyright © 2016年 zwyGame. All rights reserved.
//

import UIKit

class LeftViewController: MainViewController {
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .None
        tableView.frame = CGRectMake(20, (self.view.frame.size.height - 54 * 5) / 2.0, self.view.frame.size.width, 54 * 5)
        tableView.autoresizingMask = [.FlexibleTopMargin, .FlexibleBottomMargin, .FlexibleWidth]
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.opaque = false
        tableView.backgroundColor = UIColor.clearColor()
        tableView.backgroundView = nil
        tableView.bounces = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.clearColor()
        view.addSubview(tableView)    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}


// MARK : TableViewDataSource & Delegate Methods

extension LeftViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 54
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        let titles: [String] = ["首页", "搭配宝典", "我的收藏", ]
        
        let images: [String] = ["icon_home", "icon_match", "icon_collection",]
        
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel?.font = UIFont(name: "HelveticaNeue", size: 21)
        cell.textLabel?.textColor = ColorUtil.UIColorFromRGB("595959")
        cell.textLabel?.text  = titles[indexPath.row]
        cell.selectionStyle = .None
        cell.imageView?.image = UIImage(named: images[indexPath.row])
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            Common.homeViewController.refreshSoundButton()
            sideMenuViewController?.contentViewController = UINavigationController(rootViewController: Common.homeViewController)
            sideMenuViewController?.hideMenuViewController()
            break
        case 1:
            Common.matchViewController.refreshSoundButton()
            sideMenuViewController?.contentViewController = UINavigationController(rootViewController: Common.matchViewController)
            sideMenuViewController?.hideMenuViewController()
            break
        case 2:
            Common.collectViewController.refreshSoundButton()
            sideMenuViewController?.contentViewController = UINavigationController(rootViewController: Common.collectViewController)
            sideMenuViewController?.hideMenuViewController()
            break
        case 3:
            sideMenuViewController?.contentViewController = UINavigationController(rootViewController: Common.testNavigationController.viewControllers.first!)
            sideMenuViewController?.hideMenuViewController()
            break
        default:
            break
        }
        
        
    }
    
}
