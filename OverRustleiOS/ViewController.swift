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
import SocketIO

class ViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var toolbar: UIToolbar!
   
    @IBOutlet weak var webView: UIWebView!
    
    var player = MPMoviePlayerController()
    
    func webViewDidFinishLoad(webView: UIWebView) {
        if(webView.request?.URL != NSURL(string: "http://www.destiny.gg/embed/chat")){
            println("showing button")
            backButton.bringSubviewToFront(self.view)
            backButton.hidden = false
        } else {
            backButton.hidden = true
        }
    }
    
    @IBOutlet weak var backButton: UIButton!
    
    
    
    var socket = SocketIOClient(socketURL: "http://api.overrustle.com", opts: ["nsp": "/streams"])
    
    var api_data:NSDictionary = NSDictionary()
    
    
    @IBAction func backPressed(sender: AnyObject) {
        webView.goBack()
    }
    @IBAction func strimsPressed(sender: AnyObject) {
        
        var title = "Select Strim"
        
        if let viewers = api_data["viewercount"] as? Int {
            println("Rustlers:", viewers)
            title = "\(viewers) Rustlers Watching"
        }
        
        var list = NSArray()
        
        if let stream_list = api_data["stream_list"] as? NSArray {
            list = stream_list
            println("Stream List", stream_list)
        }
        
        
        let rustleActionSheet = UIAlertController(title: title, message: nil, preferredStyle:UIAlertControllerStyle.ActionSheet)
        
        rustleActionSheet.popoverPresentationController?.sourceView = self.view
        rustleActionSheet.popoverPresentationController?.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0)
        
        
        var i : Int
        
        for i = 0; i<list.count; i++ {
            let stream = list[i] as! NSDictionary
            if let channel = stream["channel"] as? String, let platform = stream["platform"] as? String, let imageURLString = stream["image_url"] as? String {
                var button_title = "\(channel) on \(platform)"
                if let name = stream["name"] as? String {
                    button_title = "\(name) via \(button_title)"
                }
                
                let action = UIAlertAction(title:button_title, style:UIAlertActionStyle.Default, handler:{ action in
                    println("loading", channel, "from", platform)
                    self.openStream(platform, channel: channel)
                })
                if let imageURL = NSURL(string: imageURLString) {
                    if let imageData = NSData(contentsOfURL: imageURL) {
                        let image = UIImage(data: imageData, scale: 10)
                        let originalImage = image?.imageWithRenderingMode(.AlwaysOriginal)
                        action.setValue(originalImage, forKey: "image")
                    }
                
                }
                
              
                rustleActionSheet.addAction(action)
            }
        }
        
        rustleActionSheet.addAction(UIAlertAction(title:"Cancel", style:UIAlertActionStyle.Cancel, handler:nil))
        presentViewController(rustleActionSheet, animated:true, completion:nil)
    }
    
    func openStream(platform:String, channel:String) {
        var s = RustleStream()
        switch platform {
            case "ustream":
                s = UStream()
            case "twitch":
                s = Twitch()
            case "youtube":
                s = YouTubeLive()
            case "hitbox":
                s = Hitbox()
            case "azubu":
                s = Azubu()
            case "mlg":
                s = MLG()
            default:
                println(platform, "is not supported right now")
        }
        s.channel = channel
        player.contentURL = s.getStreamURL()
        player.play()

    }
    
    func closeSocket() {
        self.socket.disconnect(fast: false)
    }
    func openSocket() {
        self.socket.connect()
    }
    
    func addHandlers() {
        // Our socket handlers go here
        
        self.socket.onAny {
            println("Got event: \($0.event)")
//            println("with items: \($0.items)")
        }
        self.socket.on("strims") { data, ack in
            println("in strims")
            
            if let new_api_data = data?[0] as? NSDictionary {
                self.api_data = new_api_data
                if let viewers = self.api_data["viewercount"] as? Int {
                    println("Rustlers:", viewers)
                }
                if let stream_list = self.api_data["stream_list"] as? NSArray {
                    println("Good Stream List")
                }
                
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        self.addHandlers()
        self.socket.connect()
        
        
        backButton.hidden = true

        
        
        let chatURL = NSURL(string: "http://www.destiny.gg/embed/chat")
        let chatURLRequestObj = NSURLRequest(URL: chatURL!)
        webView.loadRequest(chatURLRequestObj)
        
        
        
        
        
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





