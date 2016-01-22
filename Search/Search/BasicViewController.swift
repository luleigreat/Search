//
//  BasicViewController.swift
//  Search
//
//  Created by zwy on 16/1/21.
//  Copyright © 2016年 zwyGame. All rights reserved.
//

import UIKit


class MainViewController : UIViewController {
    
    var sideMenuViewController: SSASideMenu? {
        get {
            return getSideViewController(self)
        }
    }
    
    var soundBarItem: UIBarButtonItem?
    
    override func viewDidLoad() {
        var imgRightName = ""
        if AudioManager.instance().isGlobalMusicPlaying() || AudioManager.instance().isGlobalPlayerNil(){
            imgRightName = "sound"
        }else{
            imgRightName = "sound_close"
        }
        let imgRight = UIImage(named: imgRightName)?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        soundBarItem = UIBarButtonItem(image:imgRight,style:
            UIBarButtonItemStyle.Plain, target: self, action: "clickGlobalMusic")
    }
    
    private func getSideViewController(viewController: UIViewController) -> SSASideMenu? {
        if let parent = viewController.parentViewController {
            if parent is SSASideMenu {
                return parent as? SSASideMenu
            }else {
                return getSideViewController(parent)
            }
        }
        return nil
    }
    
    func refreshSoundButton(){
        if AudioManager.instance().isGlobalMusicPlaying(){
           soundBarItem?.image = UIImage(named:"sound")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        }else{
            soundBarItem?.image = UIImage(named:"sound_close")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        }
    }
    
    @IBAction func clickGlobalMusic(){
        if AudioManager.instance().isGlobalMusicPlaying(){
            AudioManager.instance().pauseGlobalMusic(true)
        }else{
            AudioManager.instance().continueGlobalMusic()
        }
        refreshSoundButton()
    }
    
    @IBAction func presentLeftMenuViewController() {
        
        sideMenuViewController?._presentLeftMenuViewController()
        
    }
    
    @IBAction func presentRightMenuViewController() {
        
        sideMenuViewController?._presentRightMenuViewController()
    }
}