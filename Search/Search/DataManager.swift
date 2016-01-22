//
//  File.swift
//  Search
//
//  Created by zwy on 16/1/14.
//  Copyright © 2016年 zwyGame. All rights reserved.
//

import UIKit

class DataManager{
    private static var singleton:DataManager? = nil
    
    static func instance()->DataManager{
        if(singleton == nil){
            singleton = DataManager()
        }
        return singleton!
    }
    
    //MARK: data collection
    private var mClothList  = Array<Cloth>()
    private var mSearchList = Array<Cloth>()
    private var mCollectList = Array<Cloth>()
    
    
    //MARK: clothes:get/set
    func getClothList()->Array<Cloth>{
        return mClothList
    }
    
    func addClothList(clothes:Array<Cloth>){
        if clothes.count > 0 && !isClothAdded(clothes[0].id!){
            mClothList += clothes
        }
    }
    
    func isClothAdded(id:String)->Bool{
        for cloth in mClothList{
            if(cloth.id == id){
                return true
            }
        }
        return false
    }
    
    func getCloth(index:Int)->Cloth?{
        if mClothList.count > index {
            return mClothList[index]
        }
        return nil
    }
    
    func clearClothList(){
        mClothList.removeAll()
    }
    
    //MARK: collection
    func isClothesCollected(id:String)->Bool{
        for cloth in mCollectList{
            if cloth.id == id{
                return true
            }
        }
        return false
    }
    func getCollectionList()->Array<Cloth>{
        return mCollectList
    }
    func addToCollectionList(cloth:Cloth){
        if !isClothesCollected(cloth.id!){
            mCollectList += [cloth]
        }
    }
    func addToCollectionList(clothList:Array<Cloth>?){
        if clothList!.count > 0 && !isClothesCollected(clothList![0].id!){
            mCollectList += clothList!
        }
    }
    func removeFromCollectionList(id:String){
        for(var i=0; i<mCollectList.count; i++){
            if mCollectList[i].id == id{
                mCollectList.removeAtIndex(i)
            }
        }
    }
    func getCollectedCloth(index:Int)->Cloth?{
        if mCollectList.count > index{
            return mCollectList[index]
        }
        return nil
    }
    func loadSavedClothes(){
        let clothesList = NSKeyedUnarchiver.unarchiveObjectWithFile(Cloth.ArchiveURL.path!) as? Array<Cloth>
        if clothesList != nil{
            DataManager.instance().addToCollectionList(clothesList!)
        }
    }
    //MARK: search
    func getSearchList()->Array<Cloth>{
        return mSearchList
    }
    func addToSearchResult(clothes:Array<Cloth>){
        if clothes.count > 0 && !isClothAddedToSearch(clothes[0].id!){
            mSearchList += clothes
        }
    }
    
    func isClothAddedToSearch(id:String)->Bool{
        for cloth in mSearchList{
            if(cloth.id == id){
                return true
            }
        }
        return false
    }
    
    func getSearchCloth(index:Int)->Cloth?{
        if mSearchList.count > index{
            return mSearchList[index]
        }
        return nil
    }
    
    func clearSearchList(){
        mSearchList.removeAll()
    }
}
