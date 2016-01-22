//
//  ViewController.swift
//  Search
//
//  Created by zwy on 16/1/11.
//  Copyright © 2016年 zwyGame. All rights reserved.
//
//  参考项目：rshankar.com/uicollectionview-demo-in-swift/
//           www.jianshu.com/p/4acbf9632a5e

import UIKit
import Alamofire

class HomeViewController: MainViewController,UICollectionViewDelegateFlowLayout{
    //MARK:UIControl
    
    @IBOutlet weak var mSearchBar: UISearchBar!
    @IBOutlet weak var mScrollViewYear: UIScrollView!
    @IBOutlet weak var mScrollViewBatch: UIScrollView!
    @IBOutlet weak var mScrollViewCategory: UIScrollView!
    @IBOutlet weak var mCollectionView: UICollectionView!
    
    @IBOutlet weak var mBtnAllYear: UIButton!
    @IBOutlet weak var mBtnAllBatch: UIButton!
    @IBOutlet weak var mBtnAllCategory: UIButton!
    
    var mMidView:DropView?
    var mMenuPopover: MLKMenuPopover?
    
    //MARK: properties
    let collectionCellIdentifier = "cellClothInfo"
    private var mBrandParam = "" as String
    private var mYearParam = "" as String
    private var mBatchParam = "" as String
    private var mCategoryParam = "" as String
    
    private var mYearBtnList = Array<UIButton>()
    private var mBatchBtnList = Array<UIButton>()
    private var mCategoryBtnList = Array<UIButton>()
    
    private var mBrandArray = ["MALABATA","SOUAD","朗立夫"]
    
    private var mPageIndex = 1
    private var mMenuBound = CGRectMake(Constants.SCREEN_WIDTH/2 - 60,44,140,132)
    
    enum ButtonType:Int{
        case year,batch,category
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorUtil.UIColorFromRGB("ecedf1")
        AudioManager.instance().playGlobalMusic()
        
        //初始化顶部导航栏
        initNavigationItem()
        
        initSearchBar()
        
        //初始化collectionView
        initCollectionView()

        //网络请求
        asyncButtonData()
        
        //初始化全部按钮
        initButtonAll()
        
        //加载保存的收藏数据
        DataManager.instance().loadSavedClothes()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let detailController = segue.destinationViewController as! DetailViewController
        if let selectedCell = sender as? ClothInfoCell{
            let indexPath = mCollectionView.indexPathForCell(selectedCell)
            let selectedCloth = DataManager.instance().getCloth(indexPath!.row)
            detailController.mCloth = selectedCloth
        }
    }
    
    private func initSearchBar(){
        mSearchBar.delegate = self
    }
    
    private func initNavigationItem(){
        //添加顶部按钮
        let imgLeft = UIImage(named: "home_collect_match_normal")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: imgLeft, style: UIBarButtonItemStyle.Plain, target: self, action: "presentLeftMenuViewController")
        
        //中间按钮
        mMidView = DropView(frame: CGRectMake(0,0,120,40))
        let tapGR = UITapGestureRecognizer(target: self, action: "midHandler:")
        mMidView!.addGestureRecognizer(tapGR)
        mMidView!.text = mBrandArray[0]
        mMidView!.backgroundColor = self.navigationController?.navigationBar.backgroundColor
        navigationItem.titleView = mMidView
        
        //背景音按钮
        navigationItem.rightBarButtonItem = soundBarItem
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
    
    func initButtonAll(){
        mBtnAllYear.setBackgroundImage(UIImage(named: "topbutton_normal"), forState: .Normal)
        mBtnAllYear.setBackgroundImage(UIImage(named: "topbutton_pushed"), forState: .Selected)
        mBtnAllBatch.setBackgroundImage(UIImage(named: "topbutton_normal"), forState: .Normal)
        mBtnAllBatch.setBackgroundImage(UIImage(named: "topbutton_pushed"), forState: .Selected)
        mBtnAllCategory.setBackgroundImage(UIImage(named: "topbutton_normal"), forState: .Normal)
        mBtnAllCategory.setBackgroundImage(UIImage(named: "topbutton_pushed"), forState: .Selected)
        mBtnAllYear.addTarget(self, action: "allBtnClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        mBtnAllBatch.addTarget(self, action: "allBtnClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        mBtnAllCategory.addTarget(self, action: "allBtnClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        mBtnAllYear.selected = true
        mBtnAllBatch.selected = true
        mBtnAllCategory.selected = true
    }
    //到底后上拉刷新
    func insertRowAtBottom(){
        if(DataManager.instance().getClothList().count % Constants.COUNT_PER_PAGE == 0){
            refreshProducts()
        }
    }
    
    private func refreshProducts(){
        var requestUrl = PathUtil.request_product_url
        requestUrl += "&page=" + mPageIndex++.description
        requestUrl += "&pageSize=" + Constants.COUNT_PER_PAGE.description
        requestUrl += mYearParam
        requestUrl += mBatchParam
        requestUrl += mBrandParam
        requestUrl += mCategoryParam
        
        
        requestNetData(requestUrl, funp: setClothesData)
    }
    //请求顶部按钮数据
    func asyncButtonData(){
        requestNetData(PathUtil.brandUrl, funp: setBrandData)
        requestNetData(PathUtil.yearUrl, funp: setYearData)
        requestNetData(PathUtil.batchUrl, funp: setBatchData)
        requestNetData(PathUtil.categoryUrl, funp: setCategoryData)
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
        
        /*
        let baseURL = PathUtil.url_base + "product.php"
        let queryItem = NSURLQueryItem(name: "batch", value: "冬季")
        let urlComponents = NSURLComponents(string: baseURL)!
        urlComponents.queryItems = [queryItem]
        let regURL = urlComponents.URL!
        let request = NSURLRequest(URL: regURL)
        
        Alamofire.request(.GET, request).responseJSON{
            response in
            switch response.result{
            case .Success:
                let jsn = JSON(response.result.value!)
                self.setBatchData(jsn)
            case .Failure(let error):
                print(error)
            }
        }*/
    }
    
    func clearData(){
        mPageIndex = 1
        DataManager.instance().clearClothList()
    }
    //新创建一个button并进行统一设置
    func getNewButton(title:String,frame:CGRect)->UIButton{
        let button = UIButton(frame: frame)
        button.setBackgroundImage(UIImage(named: "topbutton_normal"), forState: .Normal)
        button.setBackgroundImage(UIImage(named: "topbutton_pushed"), forState: .Selected)
        button.setTitle(title, forState: .Normal)
        //button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        button.setTitleColor(ColorUtil.UIColorFromRGB("595959"), forState: .Normal)
        button.titleLabel?.font = UIFont.systemFontOfSize(12)
        button.addTarget(self, action: "addedBtnClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }
    //返回衣服列表数据
    func setClothesData(json:JSON){
        let array = json["products"].array
        var clothList = Array<Cloth>()
        for clo in array!{
            let cloth = Cloth()
            cloth.parse(clo as JSON)
            clothList.append(cloth)
        }
        DataManager.instance().addClothList(clothList)
        //刷新collectionView数据显示
        mCollectionView.reloadData()
        
        mCollectionView.infiniteScrollingView.stopAnimating()
        if(clothList.count % Constants.COUNT_PER_PAGE != 0){
            mCollectionView.showsInfiniteScrolling = false
        }else{
            mCollectionView.showsInfiniteScrolling = true
        }
    }
    
    //年份数据
    func setYearData(json:JSON){
        let yearArray = json["years"].array
        for(var i=0; i<yearArray!.count;i++){
            let btn = self.getNewButton(yearArray![i].description,frame: CGRectMake(CGFloat(Int(Constants.TOP_BUTTON_WIDTH + 3)*i),0,Constants.TOP_BUTTON_WIDTH,Constants.TOP_BUTTON_HEIGHT))
            btn.tag = ButtonType.year.rawValue
            mYearBtnList.append(btn)
            self.mScrollViewYear.addSubview(btn)
        }
        self.mScrollViewYear.contentSize = CGSizeMake(CGFloat(Int(Constants.TOP_BUTTON_WIDTH + 3)*(yearArray?.count)!), Constants.TOP_BUTTON_HEIGHT)
    }
    //品牌数据
    func setBrandData(json:JSON){
        let brandArray = json["brand"].array
        if brandArray?.count > 0{
            mBrandArray.removeAll()
        }
        for(var i=0; i<brandArray!.count;i++){
            let subJson = brandArray![i] as JSON
            let brandName = subJson["name"].string!
            mBrandArray.append(brandName)
        }
        mMidView?.text = mBrandArray[0]
        mBrandParam = "&brand=" + mBrandArray[0]
        clearData()
        refreshProducts()
    }
    //产品类别
    func setCategoryData(json:JSON){
        let array = json["product_class"].array
        for(var i=0; i<array!.count;i++){
            let subJson = array![i] as JSON
            let btn = self.getNewButton(subJson["name"].string!,frame: CGRectMake(CGFloat(Int(Constants.TOP_BUTTON_WIDTH + 3)*i),0,Constants.TOP_BUTTON_WIDTH,Constants.TOP_BUTTON_HEIGHT))
            btn.tag = ButtonType.category.rawValue
            mCategoryBtnList.append(btn)
            self.mScrollViewCategory.addSubview(btn)
        }
        self.mScrollViewCategory.contentSize = CGSizeMake(CGFloat(Int(Constants.TOP_BUTTON_WIDTH + 3)*(array?.count)!), Constants.TOP_BUTTON_HEIGHT)
    }
    //产品批次
    func setBatchData(json:JSON){
        let bratchArray = json["batch"].array
        for(var i=0; i<bratchArray!.count;i++){
            let subJson = bratchArray![i] as JSON
            let btn = self.getNewButton(subJson["name"].string!,frame: CGRectMake(CGFloat(Int(Constants.TOP_BUTTON_WIDTH + 3)*i),0,Constants.TOP_BUTTON_WIDTH,Constants.TOP_BUTTON_HEIGHT))
            btn.tag = ButtonType.batch.rawValue
            mBatchBtnList.append(btn)
            self.mScrollViewBatch.addSubview(btn)
        }
        self.mScrollViewBatch.contentSize = CGSizeMake(CGFloat(Int(Constants.TOP_BUTTON_WIDTH + 3)*(bratchArray?.count)!), Constants.TOP_BUTTON_HEIGHT)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //清空选中状态
    private func clearSelection(list:Array<UIButton>){
        for button in list{
            if(button.selected){
                button.selected = false
            }
        }
    }
    
    //MARK: Button Action
    func addedBtnClicked(button : UIButton){
        
        if button.selected{
            button.selected = false
        }else{
            button.selected = true
        }
        
        let text = (button.titleLabel?.text)!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
        
        
        if button.tag == ButtonType.year.rawValue{
            if(button.selected){
                mYearParam += "&year=" + text
                if mBtnAllYear.selected{
                    mBtnAllYear.selected = false
                }
            }else{
                mYearParam = mYearParam.stringByReplacingOccurrencesOfString("&year=" + text, withString: "")
                if mYearParam.characters.count == 0{
                    mBtnAllYear.selected = true
                }
            }
        }else if button.tag == ButtonType.batch.rawValue{
            if button.selected{
                mBatchParam += "&batch=" + text
                if mBtnAllBatch.selected{
                    mBtnAllBatch.selected = false
                }
            }else{
                mBatchParam = mBatchParam.stringByReplacingOccurrencesOfString("&batch=" + text, withString: "")
                if mBatchParam.characters.count == 0{
                    mBtnAllBatch.selected = true
                }
            }
        }else if button.tag == ButtonType.category.rawValue{
            if button.selected{
                mCategoryParam += "&bigClass=" + text
                if mBtnAllCategory.selected{
                    mBtnAllCategory.selected = false
                }
            }else{
                mCategoryParam = mCategoryParam.stringByReplacingOccurrencesOfString("&bigClass=" + text, withString: "")
                if mCategoryParam.characters.count == 0{
                    mBtnAllCategory.selected = true
                }
            }
        }
        
        clearData()
        refreshProducts()
    }
    
    func allBtnClicked(button: UIButton){
        if button.selected{
            return
        }
        if button == mBtnAllYear{
            clearSelection(mYearBtnList)
            mYearParam = ""
            mBtnAllYear.selected = true
        }else if button == mBtnAllBatch{
            clearSelection(mBatchBtnList)
            mBatchParam = ""
            mBtnAllBatch.selected = true
        }else if button == mBtnAllCategory{
            clearSelection(mCategoryBtnList)
            mCategoryParam = ""
            mBtnAllCategory.selected = true
        }
        
        clearData()
        refreshProducts()
    }
    
    func midHandler(sender:UITapGestureRecognizer){
        mMenuPopover?.dismissMenuPopover()
        mMenuPopover = MLKMenuPopover(frame: mMenuBound, menuItems: mBrandArray)
        mMenuPopover?.menuPopoverDelegate = self
        mMenuPopover?.showInView(self.view)
    }
}
//MARK: collectionViewDataSource
extension HomeViewController:UICollectionViewDataSource{
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataManager.instance().getClothList().count
    }
    //展示单独的cell
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(collectionCellIdentifier,forIndexPath:indexPath) as! ClothInfoCell
        
        let cloth = DataManager.instance().getCloth(indexPath.row)
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

extension HomeViewController:MLKMenuPopoverDelegate{
    func menuPopover(menuPopover: MLKMenuPopover!, didSelectMenuItemAtIndex selectedIndex: Int) {
        mMenuPopover?.dismissMenuPopover()
        mMidView?.text = mBrandArray[selectedIndex]
        if !mBrandParam.containsString((mMidView?.text)!){
            mBrandParam = "&brand=" + mBrandArray[selectedIndex].stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
            clearData()
            refreshProducts()
        }
    }
}

extension HomeViewController: UISearchBarDelegate{
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
 
        mSearchBar.resignFirstResponder()
        let searchViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("searchViewController") as! SearchViewController
        searchViewController.clearData()
        self.navigationController?.pushViewController(searchViewController, animated: true)
        return true
    }
}
