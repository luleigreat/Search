//
//  PathUtil.swift
//  Search
//
//  Created by zwy on 16/1/13.
//  Copyright © 2016年 zwyGame. All rights reserved.
//

import Foundation

struct PathUtil{
    //请求前缀
    static let url_base = "http://101.201.208.164:8080/"
    //背景音乐
    static let globalBackgroundMusic = url_base + "music/back.mp3"
    //品牌
    static let brandUrl = url_base + "brand.php"
    //年份
    static let yearUrl = url_base + "year.php"
    //批次
    static let batchUrl = url_base + "batch.php"
    //类别
    static let categoryUrl = url_base + "productclass.php"
    //分页请求产品列表
    static let request_product_url = url_base + "product.php?"
    //搜索分页请求
    static let request_search_url = url_base + "product.php?action=search"
    //搭配宝典分类请求
    static let request_match_url = url_base + "matchclass.php"
    //搭配宝典根据类型id请求
    static let request_match_item_url = url_base + "match.php?parentId="
}