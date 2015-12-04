//
//  Hitbox.swift
//  OverRustleiOS
//
//  Created by Hayk Saakian on 8/19/15.
//  Copyright (c) 2015 Maxwell Burggraf. All rights reserved.
//

import Foundation

public class Hitbox: RustleStream {
    
    
    override func getStreamURL() -> NSURL {
        // NOTE: this endpoint won't work if the stream is offline or does not exist
        
        let url = NSURL(string:"http://api.hitbox.tv/player/hls/\(channel).m3u8")
        return url!
    }
    
    
}