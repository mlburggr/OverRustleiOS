//
//  Azubu.swift
//  OverRustleiOS
//
//  Created by Hayk Saakian on 8/19/15.
//  Copyright (c) 2015 Maxwell Burggraf. All rights reserved.
//

import Foundation

public class Azubu: RustleStream {
    
    let STATUS_ENDPOINT = "http://www.azubu.tv/api/video/active-stream/%@";
    let STREAM_ENDPOINT = "https://edge.api.brightcove.com/playback/v1/accounts/3361910549001/videos/ref:"
    
    func matchesForRegexInText(regex: String!, text: String!) -> [String] {
        let regex_options:NSRegularExpressionOptions? = NSRegularExpressionOptions.CaseInsensitive

        let regex = NSRegularExpression(pattern: regex,
            options: regex_options!, error: nil)!
        let nsString = text as NSString
        let results = regex.matchesInString(text,
            options: nil, range: NSMakeRange(0, nsString.length))
            as! [NSTextCheckingResult]
        return map(results) { nsString.substringWithRange($0.range)}
    }
    
    func getStatus() -> JSON {
        let url = NSURL(string:String(format: STATUS_ENDPOINT, channel))!
        var error:NSError?
        let retval = NSData(contentsOfURL: url, options: nil, error: &error)!
        
        let json = JSON(data: retval);

        if let results = json["total"].int {

            if results == 0 {
                return JSON("")
            }
        }
        
        return json["data"][0]
    }
    
    override func getStreamURL() -> NSURL {
        // warning: this is all assuming the stream exists and is live
        
        // get the status to generate a ref id
        // containing both the channel ID and name
        
        let status_json = getStatus()
        
        var refId = ""
        let stream_id = status_json["id"].number
        
        if stream_id != nil {
            refId = "video" + stream_id!.stringValue +
                "CH" + channel.stringByReplacingOccurrencesOfString("_", withString: "")
            
        }else{
            return NSURL()
        }
        
        // get the list of playlists
        let streamApiUrl = NSURL(string: "\(STREAM_ENDPOINT)\(refId)")!
        
        var httperror : NSError?
        let stream_api_data = NSData(contentsOfURL: streamApiUrl, options: nil, error: &httperror)!
        
        var json = JSON(data: stream_api_data)
        
        for (index: String, subJson: JSON) in json {
            
            if let source_url = subJson["src"].string {
                
                if source_url.hasSuffix("m3u8") {
                    return NSURL(string: source_url)!
                }
            }
        }
        return NSURL()
    }
}