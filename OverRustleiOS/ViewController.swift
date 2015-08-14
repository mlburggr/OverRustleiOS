//
//  ViewController.swift
//  OverRustleiOS
//
//  Created by Maxwell Burggraf on 8/8/15.
//  Copyright (c) 2015 Maxwell Burggraf. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class ViewController: UIViewController {
    
   
    @IBOutlet weak var webView: UIWebView!
    
    var player = MPMoviePlayerController()
    
    
    
    @IBAction func strimsPressed(sender: AnyObject) {
        
        
        let rustleActionSheet = UIActionSheet(title: "Select Strim", delegate: nil, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil)
        rustleActionSheet.actionSheetStyle = UIActionSheetStyle.BlackTranslucent
        
        var i : Int
        for i = 0; i<7; i++ {
            var button = UIButton()
            button.addTarget(self, action: "selected:", forControlEvents: UIControlEvents.TouchDown)
            var frame = CGRectMake(0, CGFloat(i*40 + 10), 160, 40)
            button.frame = frame
            button.tag = i
            button.setTitle("Button \(i)", forState: UIControlState.Normal)
            println("Making button \(i)")
            rustleActionSheet.addButtonWithTitle("two")
            
            rustleActionSheet.addSubview(button)
        }
        
        
//        var toolbarFrame = CGRectMake(0, 0, rustleActionSheet.bounds.size.width, 44)
//        var controlToolbar = UIToolbar(frame: toolbarFrame)
//        
//        controlToolbar.barStyle = UIBarStyle.Black
//        controlToolbar.sizeToFit()
//        
//        var spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
//        var setButton = UIBarButtonItem(title: "Set", style: UIBarButtonItemStyle.Done, target: self, action: "dismissActivityActionSheet:")
//        var cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancelActivityActionSheet:")
//        
//        
//        controlToolbar.setItems(NSArray(array: [spacer, cancelButton, setButton]) as [AnyObject], animated: false)
//        
//        rustleActionSheet.addSubview(controlToolbar)
        rustleActionSheet.bounds = CGRectMake(0, 0, 320, 485)
        rustleActionSheet.showInView(self.view)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        
        let chatURL = NSURL(string: "http://www.destiny.gg/embed/chat")
        let chatURLRequestObj = NSURLRequest(URL: chatURL!)
        webView.loadRequest(chatURLRequestObj)
        
        var myStream = RustleStream()
        myStream.platform = 1
        
        var videoStreamURL : NSURL = NSURL( string: "http://iphone-streaming.ustream.tv/ustreamVideo/20654296/streams/live/iphone/playlist.m3u8" )!
        
        player = MPMoviePlayerController(contentURL: videoStreamURL)
        
        player.view.frame = CGRectMake(0, 0, self.view.frame.size.width, 300)
        
        self.view.addSubview(player.view)
        
        player.play()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        webView.frame = CGRectMake(0, 300, self.view.frame.size.width, self.view.frame.size.height - 345);
    }
    
    


}


class RustleStream {
    //0: platform unset
    //1: ustream
    //2: twitch
    var platform : Int = 0
    var streamURL : NSURL = NSURL( string: "" )!
}

