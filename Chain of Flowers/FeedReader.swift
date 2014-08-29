//
//  FeedReader.swift
//  Chain of Flowers
//
//  Created by Xuan Nguyen on 8/19/14.
//  Copyright (c) 2014 Xuan Nguyen. All rights reserved.
//

import Foundation

public class BlogPost {
    var postGuid: String = String()
    var postTitle: String = String()
    var postLink: String = String()
    var postImage: String?
    var postDescription: String = String()
    var postPubDate = String()
}

@objc protocol FeedReaderDelegate {
    func hasFinishParsing()
}

public class FeedReader: NSObject, NSXMLParserDelegate {
    public var blogPosts: [BlogPost] = []
    
    var delegate:FeedReaderDelegate?
    
    private var eName: String = String()
    private var parser: NSXMLParser = NSXMLParser()
    private var postTitle: String = String()
    private var postLink: String = String()
    private var postGuid: String = String()
    private var postImage: String = String()
    private var postDescription: String = String()
    private var postPubDate = String()
    private var hasImage:Bool = false
    
    
    public func parse(url:String) {
        blogPosts.removeAll(keepCapacity: 0)
        parser = NSXMLParser(contentsOfURL: NSURL(string: url))
        parser.delegate = self
        parser.parse()
    }
    
    // MARK: - NSXMLParserDelegate methods
    
    //didStartElement
    public func parser(parser: NSXMLParser, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: [NSObject : AnyObject]!) {
        eName = elementName
        if elementName == "item" {
            postGuid = String()
            postTitle = String()
            postLink = String()
            postImage = String()
            postDescription = String()
            postPubDate = String()
            
        }
        
        if elementName == "media:thumbnail" {
            if let obj: String = attributeDict["url"] as AnyObject? as? String {
                postImage = obj
                hasImage = true
            }
        } else {
            hasImage = false
        }
    }
    
    //foundCharacters
    func parser(parser: NSXMLParser!, foundCharacters string: String!) {
        
        let data: String = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if (!data.isEmpty) {
            if eName == "guid" {
                postGuid += data
            } else if eName == "title" {
                postTitle += data
            } else if eName == "link" {
                postLink += data
            } else if eName == "description" {
                postDescription += data
            } else if eName == "atom:updated" {
                postPubDate += data
            }
        }
    }
    
    //didEndElement
    public func parser(parser: NSXMLParser, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!) {
        if elementName == "item" {
            let blogPost: BlogPost = BlogPost()
            blogPost.postGuid = postGuid
            blogPost.postTitle = postTitle
            blogPost.postLink = postLink
            blogPost.postDescription = postDescription
            blogPost.postPubDate = postPubDate
            
            if hasImage {
                blogPost.postImage = postImage
            } else {
                if let img:String = XNUtil.getImage(postDescription) {
                    blogPost.postImage = img
                }
            }
            blogPosts.append(blogPost)
        }
    }
    
    public func parserDidEndDocument(parser: NSXMLParser!) {
        //all parsing are complete, nofify the FeedReaderDelegate
        println("[first \(blogPosts.first?.postTitle)] [last: \(blogPosts.last?.postTitle)]")
        delegate?.hasFinishParsing()
    }
}