//
//  MatchViewController.swift
//  Search
//
//  Created by zwy on 16/1/11.
//  Copyright © 2016年 zwyGame. All rights reserved.
//

import UIKit
import Alamofire

class MatchViewController: MainViewController {
    
    //MARK:Control
    @IBOutlet weak var mCollectionView: UICollectionView!
    
    //MARK:Property
    var mCategoryDic=Dictionary<Int,String>()
    var mMatchItems=Array<Array<MatchItem>>()
    
    let cellIdentifier = "matchItemCell"
    let headerIdentifier = "matchHeaderView"
    let footerIdentifier = "matchFooterView"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorUtil.UIColorFromRGB("ebebeb")
        //scrollview上方的留白去掉
        self.automaticallyAdjustsScrollViewInsets = false
        initNavigationItem()
        initCollectionView()
        requestCategoryData()
    }
    
    func initCollectionView(){
        //设置代理
        mCollectionView.delegate = self
        mCollectionView.dataSource = self
        
        mCollectionView.alwaysBounceVertical = true
        mCollectionView.backgroundColor = ColorUtil.UIColorFromRGB("ebebeb")
        
        let layout = UICollectionViewFlowLayout()
        let widthCol = Constants.SCREEN_WIDTH - 80
        var width:CGFloat?
        //iphone6以上与以下分开处理
        if widthCol > Constants.IPHONE_6_WIDTH{
            width = (widthCol - 20) / 2
        }else{
            width = widthCol / 2
        }
        layout.itemSize = CGSizeMake(width!, width! + 30)
        
        layout.headerReferenceSize = CGSizeMake(200, 30)
        layout.footerReferenceSize = CGSizeMake(Constants.SCREEN_WIDTH - 60, 20)
        //左右间隔
        layout.minimumInteritemSpacing = 20
        //上下间隔
        layout.minimumLineSpacing = 0
        mCollectionView.collectionViewLayout = layout
    }

    func initNavigationItem(){
        title = "搭配宝典"
        let imgLeft = UIImage(named: "global_home_normal")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: imgLeft, style: UIBarButtonItemStyle.Plain, target: self, action: "presentLeftMenuViewController")
        navigationItem.rightBarButtonItem = soundBarItem
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor(),
            NSFontAttributeName: UIFont.systemFontOfSize(17)]
    }
    

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let detailController = segue.destinationViewController as! MatchDetailController
        if let selectedCell = sender as? MatchItemCell{
            let indexPath = mCollectionView.indexPathForCell(selectedCell)
            let selectedItem = mMatchItems[(indexPath?.section)!][(indexPath?.row)!]
            detailController.mMatchItem = selectedItem
        }
    }
    
    func requestCategoryData(){
        let requestUrl = PathUtil.request_match_url;
        requestNetData(requestUrl, funp: setCategoryData)
    }
    
    //请求数据，参数为闭包函数，实现回调
    func requestNetData(url:String,funp:(JSON)->Void){
        Alamofire.request(.POST, url).responseJSON{
            response in
            switch response.result{
            case .Success:
                let jsn = JSON(response.result.value!)
                funp(jsn)
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    //设置分类数据并请求每类详细数据
    func setCategoryData(json:JSON){
        let array = json["match_class"].array
        for item in array!{
            let id = item["id"].int
            let name = item["name"].string
            if id != nil{
                mCategoryDic[id!] = name
                
                let requestUrl = PathUtil.request_match_item_url + (id?.description)!
                requestNetData(requestUrl, funp: setMatchItemData)
            }
        }
    }
    //设置宝典数据
    func setMatchItemData(json:JSON){
        var itemArray = Array<MatchItem>()
        let array = json["match"].array
        for item in array!{
            let matchItem = MatchItem()
            matchItem.parse(item as JSON)
            itemArray.append(matchItem)
        }
        mMatchItems.append(itemArray)
        mCollectionView.reloadData()
    }
}

//MARK:- UICollectionView DataSource
extension MatchViewController : UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return mMatchItems.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mMatchItems[section].count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier,forIndexPath:indexPath) as! MatchItemCell
        
        let matchItem = mMatchItems[indexPath.section][indexPath.row]
        
        let url = PathUtil.url_base + matchItem.image_url
        cell.mImage.sd_setImageWithURL(NSURL(string:url), placeholderImage: UIImage(named: "defaultPhoto"))
        cell.mItemLabel.text = matchItem.name
        cell.mBackgroundView.backgroundColor = ColorUtil.UIColorFromRGB("aaaaaa")
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader{
            let headerView: MatchHeaderView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: headerIdentifier, forIndexPath: indexPath) as! MatchHeaderView
            
            headerView.mHeaderLabel.text = mCategoryDic[mMatchItems[indexPath.section][0].pid]
            return headerView
        }else{
            let footerView: MatchFooterView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: footerIdentifier, forIndexPath: indexPath) as! MatchFooterView
            if indexPath.section == mMatchItems.count - 1{
                footerView.mSidebarImg.image = nil
            }else{
                footerView.mSidebarImg.image = UIImage(named: "sidebar_dividing_line")
            }
            return footerView
        }
    }
}

// MARK:- UICollectionViewDelegate Methods

extension MatchViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //highlightCell(indexPath, flag: true)
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        //highlightCell(indexPath, flag: false)
    }
    
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        highlightCell(indexPath, flag: true)
    }
    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        highlightCell(indexPath, flag: false)
    }
    
    func highlightCell(indexPath:NSIndexPath,flag:Bool){
        let cell = mCollectionView.cellForItemAtIndexPath(indexPath) as! MatchItemCell
        if flag{
            cell.mBackgroundView.backgroundColor = UIColor.orangeColor()
        }else{
            cell.mBackgroundView.backgroundColor = UIColor.lightGrayColor()
        }
    }
}

