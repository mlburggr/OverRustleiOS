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
    
    @IBOutlet weak var toolbar: UIToolbar!
   
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
        
        

        rustleActionSheet.bounds = CGRectMake(0, 0, 320, 485)
        rustleActionSheet.showInView(self.view)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        
        let chatURL = NSURL(string: "http://www.destiny.gg/embed/chat")
        let chatURLRequestObj = NSURLRequest(URL: chatURL!)
        webView.loadRequest(chatURLRequestObj)
        
        var myStream = UStream()
        myStream.channel = "20654296"
        var videoStreamURL = myStream.getStreamURL()

   //    var videoStreamURL : NSURL = NSURL( string: "http://iphone-streaming.ustream.tv/ustreamVideo/6540154/streams/live/iphone/playlist.m3u8" )!
        
        player = MPMoviePlayerController(contentURL: videoStreamURL)
        
        //The player takes up 40% of the screen
        //(this can (and probably should be) changed later
        player.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height * 0.40)
        self.view.addSubview(player.view)
        
        player.play()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        webView.frame.size.width = self.view.frame.size.width
        webView.frame.origin.x = 0
        webView.frame.origin.y = self.view.frame.size.height * 0.40
        //The webview frame is the other 60% of the screen, minus the space that the toolbar takes up
        webView.frame.size.height = self.view.frame.size.height * 0.60 - toolbar.frame.size.height
    }
    
    


}




