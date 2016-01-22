//
//  MatchItem.swift
//  Search
//
//  Created by zwy on 16/1/19.
//  Copyright © 2016年 zwyGame. All rights reserved.
//

import UIKit

class MatchItem{
    //MARK:Properties
    var id:Int = 0
    var image_url:String = ""
    var name:String = ""
    var detail_image_url:String = ""
    var pid:Int = 0
    var last_time:String = ""
    
    func parse(json:JSON){
        self.id = json["id"].int!
        self.name = json["name"].string!
        self.image_url = json["thumb_url"].string!
        self.detail_image_url = json["mobile_image_url"].string!
        self.pid = json["pid"].int!
        self.last_time = (json["last_time"].int64?.description)!
    }
}
