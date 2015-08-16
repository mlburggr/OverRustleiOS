//
//  RustleStream.swift
//  OverRustleiOS
//
//  Created by Maxwell Burggraf on 8/15/15.
//  Copyright (c) 2015 Maxwell Burggraf. All rights reserved.
//

import Foundation


public class RustleStream {
    //0: platform unset
    //1: ustream
    //2: twitch
    var platform : Int = 0
    var streamURL : NSURL = NSURL( string: "" )!
    var channel : String = ""
    
    //TODO: useless function remove when done
    func getPlatform() -> Int{
        return platform
    }
    
    func getStreamURL() -> NSURL{
    
        if(platform==1){
            var ustreamStream = UStream()
            ustreamStream.channel = channel
            return ustreamStream.getUStreamURL()
            
        }
        if(platform==2){
            var twitchStream = Twitch()
            twitchStream.channel = channel
            return twitchStream.getTwitchURL()
        }
        return NSURL(string:"")!
        //TODO: finish
    }
}