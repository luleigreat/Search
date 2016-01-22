//
//  AudioPlayer.swift
//  Search
//
//  Created by zwy on 16/1/21.
//  Copyright © 2016年 zwyGame. All rights reserved.
//

import Foundation

class AudioPlayer:NSObject{
    var stream:AudioStreamer?
    var loop:Bool = false
    var url = ""
    
    init(url:String,bLoop:Bool = false){
        super.init()
        stream = AudioStreamer.init(URL: NSURL(string: url))
        loop = bLoop
        self.url = url
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "observeStatus:", name: ASStatusChangedNotification, object: stream)
    }
    
    func play(){
        stream?.start()
    }
    func pause(){
        stream?.pause()
    }
    
    func stop(){
        stream?.stop()
        stream = nil
    }
    
    func isPlaying()->Bool{
        return (stream?.isPlaying())!
    }
    
    func isWaiting()->Bool{
        return (stream?.isWaiting())!
    }
    
    func observeStatus(notification:NSNotification){
        if  loop && stream != nil && stream?.isFinishing() == true{
            if stream?.state == AS_STOPPED{
                stream?.seekToTime(0)
                stream?.start()
            }
        }
    }
}