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
        let jsonData : NSData = NSData(contentsOfURL: NSURL(string:"https://api.twitch.tv/kraken/streams/\(channel)")!)!
        var json = JSON(data:jsonData)
        let streamID = json["stream"]["viewers"].stringValue
        print("\(streamID)")
        
        
        //step 1: get token & sig for channel
        let authJsonData = NSData(contentsOfURL: NSURL(string:"https://api.twitch.tv/api/channels/\(channel)/access_token")!)!
        var auth = JSON(data:authJsonData)
        let token = auth["token"].stringValue
        let sig = auth["sig"].stringValue
        
        
        //TODO: Parse qualities for quality selection. Currently works if you just give it the qualitiesURL.
        print("\(sig)")
        let qualitiesString = "http://usher.justin.tv/api/channel/hls/\(channel).m3u8?token=\(token)&sig=\(sig)&allow_source=true"
        let qualitiesURL = NSURL(string:qualitiesString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
        return qualitiesURL!
        // this code will throw exceptions for offline streams:
        
        var error : NSError?
        var qualitiesNSString: NSString?
        do {
            qualitiesNSString = try NSString(contentsOfURL: qualitiesURL!, encoding: NSUTF8StringEncoding)
        } catch let error1 as NSError {
            error = error1
            qualitiesNSString = nil
        }
        let list = qualitiesNSString!.componentsSeparatedByString("\n")
        print("\(list)")
        for item in list {
            if(item.hasPrefix("#")){
            print("TEST:\(item)")
            }
        }
        return qualitiesURL!
        
    }
    
}