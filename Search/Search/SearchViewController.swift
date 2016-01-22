//
//  SearchViewController.swift
//  Search
//
//  Created by zwy on 16/1/18.
//  Copyright © 2016年 zwyGame. All rights reserved.
//

import UIKit
import Alamofire

class SearchViewController: UIViewController ,UICollectionViewDelegateFlowLayout{
    //MARK: controls

    @IBOutlet weak var mSearchBar: UISearchBar!
    @IBOutlet weak var mCollectionView: UICollectionView!
    
    //MARK: properties
    let collectionCellIdentifier = "cellSearchClothCell"
    var mPageIndex:Int = 1
    var mSearchText:String = ""
    
    override func viewDidLoad() {
        mSearchBar.becomeFirstResponder()
        mSearchBar.delegate = self
        initCollectionView()
    }
    
    override func viewDidDisappear(animated: Bool) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let detailController = segue.destinationViewController as! DetailViewController
        if let selectedCell = sender as? ClothInfoCell{
            let indexPath = mCollectionView.indexPathForCell(selectedCell)
            let selectedCloth = DataManager.instance().getSearchCloth(indexPath!.row)
            detailController.mCloth = selectedCloth
        }
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
        
        //上拉刷新
        mCollectionView.addInfiniteScrollingWithActionHandler(insertRowAtBottom)
    }
    
    //到底后上拉刷新
    func insertRowAtBottom(){
        if(DataManager.instance().getClothList().count % Constants.COUNT_PER_PAGE == 0){
            requestData()
        }
    }
    
    func clearData(){
        DataManager.instance().clearSearchList()
        mPageIndex = 1
    }
}

extension SearchViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        clearData()
        requestData()
        mSearchBar.resignFirstResponder()
    }
    
    func requestData(){
        var requestUrl = PathUtil.request_search_url;
        requestUrl += "&page=" + (mPageIndex++).description
        requestUrl += "&pageSize=" + Constants.COUNT_PER_PAGE.description
        requestUrl += "&id=" + mSearchBar.text!
        
        requestNetData(requestUrl, funp: setSearchResult)
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
    
    func setSearchResult(json:JSON){
        let array = json["products"].array
        var clothList = Array<Cloth>()
        for clo in array!{
            let cloth = Cloth()
            cloth.parse(clo as JSON)
            clothList.append(cloth)
        }
        DataManager.instance().addToSearchResult(clothList)
        //刷新collectionView数据显示
        mCollectionView.reloadData()
        
        mCollectionView.infiniteScrollingView.stopAnimating()
        if(clothList.count % Constants.COUNT_PER_PAGE != 0){
            mCollectionView.showsInfiniteScrolling = false
        }else{
            mCollectionView.showsInfiniteScrolling = true
        }
    }
}

//MARK: collectionViewDataSource
extension SearchViewController:UICollectionViewDataSource{
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataManager.instance().getSearchList().count
    }
    //展示单独的cell
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(collectionCellIdentifier,forIndexPath:indexPath) as! ClothInfoCell
        
        let cloth = DataManager.instance().getSearchCloth(indexPath.row)
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