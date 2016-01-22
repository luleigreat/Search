//
//  AudioManager.swift
//  Search
//
//  Created by zwy on 16/1/20.
//  Copyright © 2016年 zwyGame. All rights reserved.
//

import Foundation


class AudioManager{
    
    private var globalPlayer:AudioPlayer?
    private var detailBackPlayer:AudioPlayer?
    private var detailAudioPlayer:AudioPlayer?
    private var playingPlayer:AudioPlayer?
    
    private var userPauseGlobal = false
    
    class func instance()->AudioManager{
        struct Instance{
            static var onceToken: dispatch_once_t = 0
            static var instance: AudioManager?
        }
        dispatch_once(&Instance.onceToken, { () -> Void in
            Instance.instance = AudioManager()
        })
        
        return Instance.instance!
    }
    //与锁屏开屏相关
    func stopAll(){
        globalPlayer?.stop()
        if detailBackPlayer != nil{
            detailBackPlayer?.stop()
        }
        
        if detailAudioPlayer != nil{
            detailAudioPlayer?.stop()
        }
        
        globalPlayer = nil
        detailBackPlayer = nil
        detailAudioPlayer = nil
    }
    
    func pauseCurrentPlayer(){
        if playingPlayer != nil{
            playingPlayer!.pause()
        }
    }
    
    func continueCurrentPlayer(){
        if playingPlayer != nil{
            playingPlayer!.play()
        }
    }
    
    func setCurrentPlayer(player:AudioPlayer?){
        playingPlayer = player
    }
    
    //全局背景相关
    func isGlobalMusicPlaying()->Bool{
        if globalPlayer != nil{
            return ((globalPlayer?.isPlaying() == true || globalPlayer?.isWaiting() == true))
        }else{
            return false
        }
    }
    
    func isGlobalPlayerNil()->Bool{
        return globalPlayer == nil
    }
    
    func playGlobalMusic(){
        globalPlayer = AudioPlayer(url: PathUtil.globalBackgroundMusic,bLoop: true)
        globalPlayer?.play()
        setCurrentPlayer(globalPlayer)
    }
    
    func stopGlobalMusic(){
        globalPlayer?.stop()
    }
    
    func pauseGlobalMusic(bUserPause:Bool=false){
        globalPlayer?.pause()
        if bUserPause{
            setCurrentPlayer(nil)
        }
    }
    
    func continueGlobalMusic(){
        globalPlayer?.play()
        setCurrentPlayer(globalPlayer)
    }
    
    func setUserPauseGlobal(bVal:Bool){
        userPauseGlobal = bVal
    }
    func isUserPauseGlobal()->Bool{
        return userPauseGlobal
    }
    
    //衣服相关背景音乐
    func playDetailBackMusic(url:String){
        //先停止全局背景音
        if ((globalPlayer?.isPlaying()) != nil){
            globalPlayer?.pause()
        }
        detailBackPlayer = AudioPlayer(url: url,bLoop: true)
        detailBackPlayer?.play()
        setCurrentPlayer(detailBackPlayer)
    }
    
    func stopDetailBackMusic(){
        detailBackPlayer?.stop()
    }
    
    func isDetailBackPlaying()->Bool{
        if detailBackPlayer != nil{
            return (detailBackPlayer?.isPlaying())!
        }else{
            return false
        }
    }
    
    func pauseDetailBackMusic(bUserPause:Bool){
        detailBackPlayer?.pause()
        if bUserPause{
            setCurrentPlayer(nil)
        }
    }
    
    func continueDetailBackMusic(){
        detailBackPlayer?.play()
        setCurrentPlayer(detailBackPlayer)
    }
    
    //服装语音
    func playDetailAudioMusic(url:String){
        if url.characters.count == 0{
            return
        }
        if (globalPlayer?.isPlaying() == true){
            globalPlayer?.pause()
        }
        
        if (detailBackPlayer?.isPlaying() == true){
            detailBackPlayer?.pause()
        }
        
        detailAudioPlayer = AudioPlayer(url: url)
        detailAudioPlayer?.play()
    }
    
    func stopDetailAudioMusic(){
        detailAudioPlayer?.stop()
    }
    
    func isDetailAudioPlaying()->Bool{
        return (detailAudioPlayer?.isPlaying())!
    }
}