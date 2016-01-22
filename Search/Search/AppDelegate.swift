//
//  AppDelegate.swift
//  Search
//
//  Created by zwy on 16/1/11.
//  Copyright © 2016年 zwyGame. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        /*
        //通过代码连接storyboard创建navigationController
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window.makeKeyAndVisible()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        rootViewController = storyboard.instantiateViewControllerWithIdentifier("sideMenuController")
        
        navigationController = UINavigationController(rootViewController: rootViewController)
        window.rootViewController = rootViewController
        window.addSubview(navigationController.view)
        */
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        //MARK : Setup SSASideMenu
        
        let sideMenu = SSASideMenu(contentViewController: UINavigationController(rootViewController: Common.homeViewController), leftMenuViewController: LeftViewController())
        sideMenu.backgroundImage = UIImage(named: "LeftBackground")
        sideMenu.configure(SSASideMenu.MenuViewEffect(fade: true, scale: true, scaleBackground: false))
        sideMenu.configure(SSASideMenu.ContentViewEffect(alpha: 1.0, scale: 0.7))
        sideMenu.configure(SSASideMenu.ContentViewShadow(enabled: true, color: UIColor.blackColor(), opacity: 0.6, radius: 6.0))
        
        window?.rootViewController = sideMenu
        window?.makeKeyAndVisible()

        //缓存大小
        SDImageCache.sharedImageCache().maxCacheSize=1024*1024*15
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        AudioManager.instance().pauseCurrentPlayer()
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        AudioManager.instance().continueCurrentPlayer()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func applicationDidReceiveMemoryWarning(application: UIApplication) {
        SDImageCache.sharedImageCache().clearMemory()
        SDWebImageManager.sharedManager().cancelAll()
    }
}

