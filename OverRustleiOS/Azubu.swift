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
    let ACCOUNT_ID = "3361910549001"
    let STREAM_ENDPOINT = "https://edge.api.brightcove.com/playback/v1/accounts/3361910549001/videos/ref:"
    
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
        
        // get the config js file
        let config_url = step1()
        if config_url == nil {
            return NSURL()
        }
        
        // get the policy container url
        let policy_url = step2(config_url!)
        if policy_url == nil {
            return NSURL()
        }
        
        // get the policy key from the container url
        let policy_key = step3(policy_url!)
        
        // get the list of playlists
        let streamApiUrl = NSURL(string: "\(STREAM_ENDPOINT)\(refId)")!
        
        var request = NSMutableURLRequest(URL: streamApiUrl)
        // set the special header
        request.addValue(policy_key, forHTTPHeaderField: "BCOV-Policy")
        var response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
        var dataVal: NSData =  NSURLConnection.sendSynchronousRequest(request, returningResponse: response, error:nil)!
        var err: NSError
        println(response)
        
        var json = JSON(data: dataVal)["sources"]
        
        for (index: String, subJson: JSON) in json {
            
            if let source_url = subJson["src"].string {
                // find the first HLS playlist
                if source_url.hasSuffix("m3u8") {
                    return NSURL(string: source_url)!
                }
            }
        }
        return NSURL()
    }
    
    func step1() -> NSURL? {
        var error:NSError?
        
        let html = NSString(contentsOfURL: NSURL(string:"http://www.azubu.tv/\(channel)")!, encoding: NSUTF8StringEncoding, error: &error)! as String
        
        let matches = matchesForRegexInText("config\\/config\\..+?\\.js", text: html)
        
        if matches.count < 1 {
            return nil
        }
        
        let config_js_path = matches[0]
        
        return NSURL(string: "http://azubu.tv/\(config_js_path)")
    }
    
    func step2(url:NSURL) -> NSURL? {
        var error:NSError?
        
        let html = NSString(contentsOfURL: url, encoding: NSUTF8StringEncoding, error: &error)! as String
        
        let matches = matchesForRegexInText("(\\S{8}?-\\S{4}?-\\S{4}?-\\S{4}?-\\S{12})", text: html)
        
        if matches.count < 1 {
            return nil
        }
        
        let player_key = matches[0]
        
        return NSURL(string: "http://players.brightcove.net/\(ACCOUNT_ID)/\(player_key)_default/index.js")
    }
    
    func step3(url:NSURL) -> String? {
        var error:NSError?
        
        let html = NSString(contentsOfURL: url, encoding: NSUTF8StringEncoding, error: &error)! as String
        
        let matches = matchesForRegexInText("'policyKey':\\s\"(\\S+?)\"", text: html)
        
        if matches.count < 1 {
            return nil
        }
        
        let policy_key = matches[0]
        
        return policy_key.substringWithRange(Range<String.Index>(start: advance(policy_key.startIndex, 14), end: advance(policy_key.endIndex, -1)))
        //"llo, playgroun"
        
    }
}