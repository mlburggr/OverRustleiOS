//
//  MLG.swift
//  OverRustleiOS
//
//  Created by Hayk Saakian on 8/20/15.
//  Copyright (c) 2015 Maxwell Burggraf. All rights reserved.
//

import Foundation

public class MLG: RustleStream {
    
    let PLAYER_EMBED_URL = "http://www.majorleaguegaming.com/player/embed/"
    let STREAM_API_URL = "http://streamapi.majorleaguegaming.com/service/streams/playback/%@?format=all"
    
    let stream_config_regex = "var playerConfig = (.+);"
    
    override func getStreamURL() -> NSURL {
        // warning: this is all assuming the stream exists and is live
        
        // step 1: figure out the mlgXYZ id
        // 1a: get the html containing the data
        var error: NSError?
        var url = NSURL(string: "\(PLAYER_EMBED_URL)\(channel)")!
        var res = (try! NSString(contentsOfURL: url, encoding: NSUTF8StringEncoding)) as String

        // 1b: pull the id from the json on the page
        let stream_id = findStreamId(res)
        
        if stream_id == nil {
            return NSURL()
        }
        
        // step 2: get the streams list
        url = NSURL(string:String(format: STREAM_API_URL, stream_id!))!
        
        let stream_api_data = try! NSData(contentsOfURL: url, options: [])
        let streams = JSON(data: stream_api_data)["data"]["items"]
        for (index, subJson): (String, JSON) in streams {
            
            if let source_url = subJson["url"].string {
                // find the first HLS playlist
                if source_url.hasSuffix("m3u8") {
                    return NSURL(string: source_url)!
                }
            }
        }
        
        return NSURL()
    }
    
    func findStreamId(html: String) -> String? {
        let matches = matchesForRegexInText(stream_config_regex, text: html)
        if matches.count == 0 {
            return nil
        }
        
        let json_string = matches[0].substringWithRange(Range<String.Index>(start: matches[0].startIndex.advancedBy(19), end: matches[0].endIndex.advancedBy(-1)))
        print("json string \(json_string)")
        
        if let dataFromString = json_string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            let json = JSON(data: dataFromString)
            let id = json["media"]["stream_name"].string
            
            return id
        }
        return nil
    }
    
}
