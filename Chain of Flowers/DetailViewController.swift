//
//  DetailViewController.swift
//  Chain of Flowers
//
//  Created by Xuan Nguyen on 8/5/14.
//  Copyright (c) 2014 Xuan Nguyen. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController , UIWebViewDelegate {
    
    @IBOutlet var webView:UIWebView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var postLink: String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(postLink == "") {
            postLink = "http://craigjparker.blogspot.com"
        }
        let url: NSURL = NSURL(string: postLink)
        let request: NSURLRequest = NSURLRequest(URL: url)
        webView.loadRequest(request)
        webView.delegate = self
    }
    
    func webViewDidStartLoad(webView: UIWebView!)  {
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(webView: UIWebView!)  {
        activityIndicator.hidden = true
        activityIndicator.stopAnimating()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

