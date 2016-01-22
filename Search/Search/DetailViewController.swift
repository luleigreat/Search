//
//  DetailViewController.swift
//  Search
//
//  Created by zwy on 16/1/18.
//  Copyright © 2016年 zwyGame. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var mScrollView: UIScrollView!
    @IBOutlet weak var mToolBar: UIToolbar!

    
    @IBOutlet weak var mInfoBack: UIView!
    @IBOutlet weak var mInfoName: UILabel!
    @IBOutlet weak var mInfoID: UILabel!
    @IBOutlet weak var mInfoPrice: UILabel!
    @IBOutlet weak var mInfoDescription: UILabel!
    
    var mImageDetail: UIImageView?
    var mBtnBackMusic: UIButton?
    var mBtnSoundMusic: UIButton?
    var mBtnInfo : UIButton?
    
    var mCloth:Cloth?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AudioManager.instance().playDetailBackMusic((mCloth?.detail_back_music)!)
        
        configureNavigationBar()
        //加载图片
        loadImage()
        
        //动态添加toolbar上的button
        configureToolbarItem()
        //详细信息
        configureDetailInfo()
    }
    
    func configureNavigationBar(){
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: self, action: "clickBack")
        var collectImgName:String
        if DataManager.instance().isClothesCollected((mCloth?.id)!){
            collectImgName = "collected"
        }else{
            collectImgName = "uncollected"
        }
        let imgRight = UIImage(named: collectImgName)?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image:imgRight,style:
            UIBarButtonItemStyle.Plain, target: self, action: "clickCollect")
        navigationItem.title = mCloth?.name
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor(),
            NSFontAttributeName: UIFont.systemFontOfSize(17)]
        
    }
    
    func loadImage(){
        //SDWebImage的缓存机制
        let imageNetURL = NSURL(string: PathUtil.url_base + (mCloth?.detail_pic_url)!)!
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
        let imageNetURL = PathUtil.url_base + (mCloth?.detail_pic_url)!
        SDImageCache.sharedImageCache().queryDiskCacheForKey(imageNetURL, done: { (image:UIImage!, cacheType:SDImageCacheType) -> Void in
            
            self.mImageDetail = UIImageView(image: image)
            let size = CGSize(width: Constants.SCREEN_WIDTH,
                height: image.size.height/image.size.width * (Constants.SCREEN_WIDTH))
            self.mImageDetail?.frame = CGRect(origin: CGPoint(x: 4,y: 0), size: size)
            self.mScrollView.addSubview(self.mImageDetail!)
            self.mScrollView.contentSize = (self.mImageDetail?.frame.size)!
        })
    }
    
    func saveClothes()->Bool{
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(DataManager.instance().getCollectionList(), toFile: Cloth.ArchiveURL.path!)
        return isSuccessfulSave
    }
    
    func configureToolbarItem(){
        addBackMusicBtn()
        addClothSoundBtn()
        addDetailInfoBtn()
    }
    
    func configureDetailInfo(){
        mInfoBack.backgroundColor = ColorUtil.UIColorFromRGB("ffffff",alpha:230/255)
        mInfoName.text = mCloth?.name
        mInfoID.text = "ID：" + (mCloth?.id)!
        mInfoPrice.text = "¥" + (mCloth?.price?.description)!
        mInfoPrice.textColor = ColorUtil.UIColorFromRGB("ea7565")
        mInfoDescription.text = mCloth?.detail_description
    }
    
    func setButtonCommon(btn:UIButton){
        btn.setBackgroundImage(UIImage(named: "topbutton_normal"), forState: .Normal)
        btn.setBackgroundImage(UIImage(named: "topbutton_pushed"), forState: .Highlighted)
        btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        btn.titleLabel?.font = UIFont.systemFontOfSize(12)
    }
    
    func addBackMusicBtn(){
        //背景音
        let btn = UIButton(frame: CGRectMake(20,10,80,28))
        btn.imageView?.frame = CGRectMake(0, 0, 24, 24)
        btn.setImage(UIImage(named: "sound_open_normal"), forState: .Normal)
        btn.setTitle("背景音", forState: .Normal)
        btn.contentHorizontalAlignment = .Left
        btn.addTarget(self, action: "backMusicClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        setButtonCommon(btn)
        mBtnBackMusic = btn
        mToolBar.addSubview(btn)
    }
    
    func addClothSoundBtn(){
        //语音
        let btn = UIButton(frame: CGRectMake(110,10,80,28))
        btn.imageView?.frame = CGRectMake(0, 0, 24, 24)
        btn.setImage(UIImage(named: "sound_play_normal"), forState: .Normal)
        btn.setTitle("语音", forState: .Normal)
        setButtonCommon(btn)
        btn.contentHorizontalAlignment = .Left
        btn.addTarget(self, action: "soundMusicClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        mBtnSoundMusic = btn
        mToolBar.addSubview(btn)
    }
    
    func addDetailInfoBtn(){
        //+信息
        let btn = UIButton(frame: CGRectMake(Constants.SCREEN_WIDTH-90,10,80,28))
        btn.setTitle("+信息", forState: .Normal)
        setButtonCommon(btn)
        btn.addTarget(self, action: "infoBtnClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        mBtnInfo = btn
        mToolBar.addSubview(btn)
    }
    
    func pauseDetailBackMusic(){
        AudioManager.instance().pauseDetailBackMusic(true)
        mBtnBackMusic!.setImage(UIImage(named: "sound_close_normal"), forState: .Normal)
    }
    
    //MARK:actions
    func backMusicClicked(button : UIButton){
        if AudioManager.instance().isDetailBackPlaying(){
            pauseDetailBackMusic()
        }else{
            AudioManager.instance().continueDetailBackMusic()
            mBtnBackMusic!.setImage(UIImage(named: "sound_open_normal"), forState: .Normal)
        }
    }
    
    func soundMusicClicked(button: UIButton){
        AudioManager.instance().playDetailAudioMusic((mCloth?.detail_desc_music)!)
    }

    override func viewWillDisappear(animated: Bool) {
       
        AudioManager.instance().stopDetailBackMusic()
        AudioManager.instance().stopDetailAudioMusic()
        
        //
        if !AudioManager.instance().isUserPauseGlobal(){
            AudioManager.instance().continueGlobalMusic()
        }
    }
    func clickCollect(){
        var imgName = ""
        if DataManager.instance().isClothesCollected((mCloth?.id)!){
            DataManager.instance().removeFromCollectionList((mCloth?.id)!)
            imgName = "uncollected"
            SVProgressHUD.showSuccessWithStatus("取消收藏成功")

        }else{
            DataManager.instance().addToCollectionList(mCloth!)
            imgName = "collected"
            SVProgressHUD.showSuccessWithStatus("收藏成功")
        }
        if saveClothes(){
            let imgRight = UIImage(named: imgName)?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
            navigationItem.rightBarButtonItem?.image = imgRight
            
            let collectionController = Common.collectViewController
            collectionController.refresh()
        }
    }
    
    func infoBtnClicked(button : UIButton){
        if mInfoBack.hidden == false{
            mInfoBack.hidden = true
            mBtnInfo?.setTitle("+信息", forState: .Normal)
        }else{
            mInfoBack.hidden = false
            mBtnInfo?.setTitle("-信息", forState: .Normal)
        }
    }
}
