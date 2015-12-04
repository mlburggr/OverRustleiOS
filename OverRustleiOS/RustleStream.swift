//
//  RustleStream.swift
//  OverRustleiOS
//
//  Created by Maxwell Burggraf on 8/15/15.
//  Copyright (c) 2015 Maxwell Burggraf. All rights reserved.
//

import Foundation


public class RustleStream {

    var platform : Int = 0
    var streamURL : NSURL = NSURL( string: "" )!
    var channel : String = ""
    
    func matchesForRegexInText(regex: String!, text: String!) -> [String] {
        let regex_options:NSRegularExpressionOptions? = NSRegularExpressionOptions.CaseInsensitive
        
        let regex = try! NSRegularExpression(pattern: regex,
            options: regex_options!)
        
        let nsString = text as NSString
        let results = regex.matchesInString(text,
            options: [], range: NSMakeRange(0, nsString.length))
            
        return results.map { nsString.substringWithRange($0.range)}
    }
    
    func getStreamURL() -> NSURL{
    

        return NSURL(string:"")!
        
    }
}