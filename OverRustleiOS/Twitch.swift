//
//  Twitch.swift
//  OverRustleiOS
//
//  Created by Maxwell Burggraf on 8/15/15.
//  Copyright (c) 2015 Maxwell Burggraf. All rights reserved.
//

import Foundation

public class Twitch: RustleStream {
    
    
        override func getStreamURL() -> NSURL {
        var jsonData : NSData = NSData(contentsOfURL: NSURL(string:"https://api.twitch.tv/kraken/streams/destiny")!)!
        var json = JSON(data:jsonData)
        var streamID = json["stream"]["viewers"].stringValue
        println("\(streamID)")
        
        
        //step 1: get token & sig for channel
        var authJsonData = NSData(contentsOfURL: NSURL(string:"https://api.twitch.tv/api/channels/destiny/access_token")!)!
        var auth = JSON(data:authJsonData)
        var token = auth["token"].stringValue
        var sig = auth["sig"].stringValue
        
        
        //TODO: Parse qualities for quality selection. Currently works if you just give it the qualitiesURL.
        println("\(sig)")
        var qualitiesString = "http://usher.justin.tv/api/channel/hls/\(channel).m3u8?token=\(token)&sig=\(sig)&allow_source=true"
        var qualitiesURL = NSURL(string:qualitiesString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
        var error : NSError?
        var qualitiesNSString = NSString(contentsOfURL: qualitiesURL!, encoding: NSUTF8StringEncoding, error: &error)
        var list = qualitiesNSString!.componentsSeparatedByString("\n")
        println("\(list)")
        for item in list {
            if(item.hasPrefix("#")){
            println("TEST:\(item)")
            }
        }
        return qualitiesURL!
        
    }
    
}