//
//  MasterViewController.swift
//  Chain of Flowers
//
//  Created by Xuan Nguyen on 8/5/14.
//  Copyright (c) 2014 Xuan Nguyen. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController, FeedReaderDelegate {
    private let feedUrl:String = "http://craigjparker.blogspot.com/feeds/posts/default?alt=rss&start-index=1"
    private let maxResults = 20
    
    private var feedReader:FeedReader = FeedReader()
    private var blogPosts: [BlogPost] = []
    private var hasImage:Bool = false
    private var startIndex:Int = 1
    private var imageCache = [String : UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        let url = feedUrl + "&max-results=\(maxResults)"
        feedReader.delegate = self
        feedReader.parse(url)
        super.viewDidAppear(animated)
    }
    
//FAIL!
//    private func getImageUrl(rawHtml:String) -> String? {
//        let regex = NSRegularExpression(pattern: "<\\s*?img\\s+[^>]*?\\s*src\\s*=\\s*([\"\'])((\\\\?+.)*?)\\1[^>]*?>", options: NSRegularExpressionOptions.CaseInsensitive, error: nil)
//        let match:NSTextCheckingResult? = regex.firstMatchInString(rawHtml, options: nil, range: NSMakeRange(0, rawHtml.utf16Count))
//        if let m = match {
//            let imgUrl = rawHtml.substringWithRange(m.rangeAtIndex(2))
//            return imgUrl
//        }
//        return nil
//    }
    
    // MARK: - FeedReaderDelegate impl
    
    func hasFinishParsing() {
        blogPosts += feedReader.blogPosts
        tableView.reloadData()
    }
    
    // MARK: - Table view data source impl
    
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return blogPosts.count
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        
        let blogPost: BlogPost = blogPosts[indexPath.row]
        // Add a check to make sure this exists
        let cellText: String = blogPost.postTitle
        cell.textLabel.text = cellText
        cell.imageView.image = UIImage(named: "Blank52")
        
        // Grab the artworkUrl60 key to get an image URL for the app's thumbnail
        if let urlString = blogPost.postImage {
            
            // Check our image cache for the existing key. This is just a dictionary of UIImages
            var image = self.imageCache[urlString]
            
            if let urlString = blogPost.postImage {
                // If the image does not exist, we need to download it
                var imgURL: NSURL = NSURL(string: urlString)
                
                // Download an NSData representation of the image at the URL
                let request: NSURLRequest = NSURLRequest(URL: imgURL)
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                    if error == nil {
                        image = UIImage(data: data)
                        
                        // Store the image in to our cache
                        self.imageCache[urlString] = image
                        if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) {
                            cellToUpdate.imageView.image = image
                        }
                    }
                    else {
                        println("Error: \(error.localizedDescription)")
                    }
                })
                
            }
            else {
                dispatch_async(dispatch_get_main_queue(), {
                    if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) {
                        cellToUpdate.imageView.image = image
                    }
                })
            }
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return 120.0
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView!) {
        var offset = scrollView.contentOffset.y
        var maxOffset = scrollView.contentSize.height - scrollView.frame.size.height
        //check to see of scroll hit bottom
        if ((maxOffset - offset) <= 40) && blogPosts.count > 0 {
            startIndex = blogPosts.count + 20
            let q = "http://craigjparker.blogspot.com/feeds/posts/default?alt=rss&start-index=\(startIndex)"
            println(q)
            feedReader.parse(q)
        }
    }
    
    // MARK: - segue
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!)  {
        if segue.identifier == "showDetail" {
            let indexPath = self.tableView.indexPathForSelectedRow()
            let blogPost: BlogPost = blogPosts[tableView.indexPathForSelectedRow().row]
            let controller = (segue.destinationViewController as UINavigationController).topViewController as DetailViewController
            controller.postLink = blogPost.postLink
            controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem()
        }
    }
}