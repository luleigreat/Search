//
//  Cloth.swift
//  Search
//
//  Created by zwy on 16/1/14.
//  Copyright © 2016年 zwyGame. All rights reserved.
//

import UIKit

struct PropertyKey{
    static let nameKey = "name"
    static let idKey = "id"
    static let priceKey = "price"
    static let picUrkKey = "picUrl"
    static let update_timeKey = "update_time"
    static let detail_descKey = "detail_desc"
    static let detail_pic_urlKey = "detail_pic_url"
    static let detail_back_musicKey = "detail_back_music"
    static let detail_desc_musicKey = "detail_desc_music"
}

class Cloth : NSObject,NSCoding{
    //MARK: Properties
    var name:String?
    var id:String?
    var price:Int?
    var picUrl:String?
    var update_time:String?
    var detail_description:String?
    var detail_pic_url:String?
    var detail_back_music:String?
    var detail_desc_music:String?
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("Clothes")
    
    func parse(json:JSON){
        self.id = json["id"].string
        self.name = json["name"].string
        self.price = json["price"].int
        self.picUrl = json["thumb_url"].string
        self.update_time = json["last_time"].int64?.description
        self.detail_description = json["memo"].string
        self.detail_pic_url = json["mobile_image_url"].string
        self.detail_back_music = PathUtil.url_base + json["audio_back"].string!
        self.detail_desc_music = json["audio_desc"].string
        if self.detail_desc_music == nil{
            self.detail_desc_music = ""
        }else{
            detail_desc_music = PathUtil.url_base + detail_desc_music!
        }
    }
    
    override init(){
        super.init()
    }
    
    //MARK:NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeObject(id, forKey: PropertyKey.idKey)
        aCoder.encodeInteger(price!, forKey: PropertyKey.priceKey)
        aCoder.encodeObject(picUrl, forKey: PropertyKey.picUrkKey)
        aCoder.encodeObject(update_time, forKey: PropertyKey.update_timeKey)
        aCoder.encodeObject(detail_description, forKey: PropertyKey.detail_descKey)
        aCoder.encodeObject(detail_pic_url, forKey: PropertyKey.detail_pic_urlKey)
        aCoder.encodeObject(detail_back_music, forKey: PropertyKey.detail_back_musicKey)
        aCoder.encodeObject(detail_desc_music, forKey: PropertyKey.detail_desc_musicKey)
    }
    
    init?(name:String,id:String,price:Int,picUrl:String, update_time:String,detail_desc:String,
        detail_pic_url:String,detail_back_music:String,detail_desc_music:String){
            self.name = name
            self.id = id
            self.price = price
            self.picUrl = picUrl
            self.update_time = update_time
            self.detail_description = detail_desc
            self.detail_pic_url = detail_pic_url
            self.detail_back_music = detail_back_music
            self.detail_desc_music = detail_desc_music
            
            super.init()
            
            if name.isEmpty{
                return nil
            }
    }
    
    required convenience init?(coder aDecoder:NSCoder){
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        let id = aDecoder.decodeObjectForKey(PropertyKey.idKey) as! String
        let price = aDecoder.decodeIntegerForKey(PropertyKey.priceKey) 
        let picUrl = aDecoder.decodeObjectForKey(PropertyKey.picUrkKey) as! String
        let update_time = aDecoder.decodeObjectForKey(PropertyKey.update_timeKey) as! String
        let detail_desc = aDecoder.decodeObjectForKey(PropertyKey.detail_descKey) as! String
        let detail_pic_url = aDecoder.decodeObjectForKey(PropertyKey.detail_pic_urlKey) as! String
        let detail_back_music = aDecoder.decodeObjectForKey(PropertyKey.detail_back_musicKey) as! String
        let detail_desc_music = aDecoder.decodeObjectForKey(PropertyKey.detail_desc_musicKey) as! String
        
        //Must call designated initializer
        self.init(name:name,id:id,price:price,picUrl:picUrl,update_time:update_time,detail_desc: detail_desc,
            detail_pic_url:detail_pic_url,detail_back_music:detail_back_music,detail_desc_music:detail_desc_music)
    }
}
