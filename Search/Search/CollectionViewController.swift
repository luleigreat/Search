//
//  CollectionViewController.swift
//  Search
//
//  Created by zwy on 16/1/11.
//  Copyright © 2016年 zwyGame. All rights reserved.
//

import UIKit

class CollectionViewController: MainViewController,UICollectionViewDelegateFlowLayout{
    
    //MARK:controls
    @IBOutlet weak var mCollectionView: UICollectionView!
    
    let collectionCellIdentifier = "cellCollectionCloth"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        //scrollview上方的留白去掉
        self.automaticallyAdjustsScrollViewInsets = false
        
        initNavigationItem()
        initCollectionView()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let detailController = segue.destinationViewController as! DetailViewController
        if let selectedCell = sender as? ClothInfoCell{
            let indexPath = mCollectionView.indexPathForCell(selectedCell)
            let selectedCloth = DataManager.instance().getCollectedCloth(indexPath!.row)
            detailController.mCloth = selectedCloth
        }
    }
    
    func refresh(){
        if mCollectionView != nil{
            mCollectionView.reloadData()
        }
    }
    
    func initNavigationItem(){
        title = "我的收藏"
        /*self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor(),
            NSFontAttributeName: UIFont.systemFontOfSize(20)]*/

        let imgLeft = UIImage(named: "global_home_normal")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: imgLeft, style: UIBarButtonItemStyle.Plain, target: self, action: "presentLeftMenuViewController")
        navigationItem.rightBarButtonItem = soundBarItem
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor(),
            NSFontAttributeName: UIFont.systemFontOfSize(17)]
    }
    
    //初始化collectionView控件
    private func initCollectionView(){
        //设置代理
        mCollectionView.delegate = self
        mCollectionView.dataSource = self
        
        mCollectionView.alwaysBounceVertical = true
        
        let layout = UICollectionViewFlowLayout()
        let widthCol = Constants.SCREEN_WIDTH - 10
        var width:CGFloat?
        //iphone6以上与以下分开处理
        if widthCol > Constants.IPHONE_6_WIDTH{
            width = (widthCol - 10) / 2
        }else{
            width = widthCol / 2
        }
        let height = width! * 1.45
        layout.itemSize = CGSizeMake(width!, height)
        //左右间隔
        layout.minimumInteritemSpacing = 0
        //上下间隔
        layout.minimumLineSpacing = 0
        mCollectionView.collectionViewLayout = layout
    }
    
}

extension CollectionViewController:UICollectionViewDataSource{
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataManager.instance().getCollectionList().count
    }
    //展示单独的cell
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(collectionCellIdentifier,forIndexPath:indexPath) as! ClothInfoCell
        
        let cloth = DataManager.instance().getCollectedCloth(indexPath.row)
        let url = PathUtil.url_base + cloth!.picUrl!
        cell.mIdLabel.text = "ID:" + cloth!.id!
        //异步加载图片，并缓存下来
        cell.mClothImage.sd_setImageWithURL(NSURL(string:url), placeholderImage: UIImage(named: "defaultPhoto"))
        cell.mClothName.text = cloth!.name
        cell.mPrice.text = "¥" + (cloth!.price?.description)!
        cell.mPrice.textColor = ColorUtil.UIColorFromRGB("ea7565")
        
        return cell
    }
}
