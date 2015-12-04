//
//  UStream.swift
//  OverRustleiOS
//
//  Created by Maxwell Burggraf on 8/15/15.
//  Copyright (c) 2015 Maxwell Burggraf. All rights reserved.
//

import Foundation

public class UStream: RustleStream {
    
    
    override func getStreamURL() -> NSURL {
        let url = NSURL(string:"http://iphone-streaming.ustream.tv/ustreamVideo/\(channel)/streams/live/iphone/playlist.m3u8")
        return url!
    }
    
    
}