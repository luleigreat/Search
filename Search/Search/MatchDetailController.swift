//
//  MatchDetailController.swift
//  Search
//
//  Created by zwy on 16/1/20.
//  Copyright © 2016年 zwyGame. All rights reserved.
//

import UIKit

class MatchDetailController: UIViewController {
    //MARK:Controls
    @IBOutlet weak var mScrollView: UIScrollView!
    
    var mImageDetail:UIImageView?
    //MARK:Properties
    var mMatchItem:MatchItem?
    
    override func viewDidLoad() {
        //scrollview上方的留白去掉
        self.automaticallyAdjustsScrollViewInsets = false
        
        configureNavigationBar()
        //加载图片
        loadImage()
    }
    
    func configureNavigationBar(){
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        navigationItem.title = mMatchItem?.name
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor(),
            NSFontAttributeName: UIFont.systemFontOfSize(17)]
    }
    
    func loadImage(){
        //SDWebImage的缓存机制
        let imageNetURL = NSURL(string: PathUtil.url_base + (mMatchItem?.detail_image_url)!)!
        SDWebImageManager.sharedManager().downloadImageWithURL(imageNetURL, options: SDWebImageOptions(), progress: { (min:Int, max:Int) -> Void in
                //print("加载中 ")
                if min == 0{
                    SVProgressHUD.showWithStatus("加载中")
                }
            }) { (image:UIImage!, error:NSError!, cacheType:SDImageCacheType, finished:Bool, url:NSURL!) -> Void in
                SVProgressHUD.dismiss()
                //这里属于sdwebimage线程，不能在这里做改变ui布局的动作
                if (image != nil)
                {
                    self.reloadInputViews()
                }
        }
    }
    
    override func reloadInputViews() {
        let imageNetURL = PathUtil.url_base + (mMatchItem?.detail_image_url)!
        SDImageCache.sharedImageCache().queryDiskCacheForKey(imageNetURL, done: { (image:UIImage!, cacheType:SDImageCacheType) -> Void in
            
            self.mImageDetail = UIImageView(image: image)
            let size = CGSize(width: Constants.SCREEN_WIDTH,
                height: image.size.height/image.size.width * (Constants.SCREEN_WIDTH))
            self.mImageDetail?.frame = CGRect(origin: CGPoint(x: 4,y: 0), size: size)
            self.mScrollView.addSubview(self.mImageDetail!)
            self.mScrollView.contentSize = (self.mImageDetail?.frame.size)!
        })
    }
}
