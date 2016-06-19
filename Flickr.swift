//
//  Photo.swift
//  Virtual_Tourist_FatihUstok
//
//  Created by Refik Fatih Ustok on 20/05/16.
//  Copyright © 2016 Refik Fatih Ustok. All rights reserved.
//

import Foundation
import CoreData
import UIKit

/*
* Photo model represents photos from Flickr
*/
class Photo: NSManagedObject {
    
    @NSManaged var id: String
    @NSManaged var url: String
    @NSManaged var pin: Pin
    
    // Store current downloading file task
    var task: NSURLSessionTask? = nil
    
    // File path... we also use path as cache key :)
    lazy var filePath: String = {
        return NSFileManager.defaultManager()
            .URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
            .URLByAppendingPathComponent("image-\(self.id).jpg").path!
        }()
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(id: String, url: String, pin: Pin, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Photo", inManagedObjectContext: context)
        super.init(entity: entity!, insertIntoManagedObjectContext: context)
        
        self.id = id
        self.url = url
        self.pin = pin
    }
    
    /*
    * Make Photo object from Flickr search result photo object
    */
    init(flickrDictionary: [String: AnyObject], pin: Pin, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Photo", inManagedObjectContext: context)
        super.init(entity: entity!, insertIntoManagedObjectContext: context)
        
        self.id = flickrDictionary["id"] as! String
        self.url = flickrDictionary["url_m"] as! String
        self.pin = pin
    }
    
    /*
    * Download image by url in background task
    */
    func startLoadingImage(handler: (image : UIImage?, error: String?) -> Void) {
        // Check in memory
        if let image = CacheForMemory.get(filePath) {
            print("Photo loaded from memory cache")
            return handler(image: image, error: nil)
        }
        
        // Check in file system
        if let image = CacheForFile.get(filePath) {
            print("Photo loaded from file cache")
            return handler(image: image, error: nil)
        }
        
        // Cancel existing task to prevent traffic flow
        cancelLoadingImage()
        
        task = NSURLSession.sharedSession().dataTaskWithRequest(NSURLRequest(URL: NSURL(string: url)!)) { data, response, downloadError in
            dispatch_async(dispatch_get_main_queue(), {
                guard downloadError == nil else {
                    print("Photo loading canceled")
                    return handler(image: nil, error: "Photo loadnig canceled")
                }
                
                guard let data = data, let image = UIImage(data: data) else {
                    print("Photo not loaded")
                    return handler(image: nil, error: "Photo not loaded")
                }
                
                CacheForMemory.set(image, forKey: self.filePath)
                CacheForFile.set(image, forPath: self.filePath)
                
                print("Photo loaded from internet")
                return handler(image: image, error: nil)
            })
        }
        task!.resume()
    }
    
    /*
    * Cancel downloading process if it's running
    */
    func cancelLoadingImage() {
        task?.cancel()
    }
    
    /*
    * Remove image from local storage when photo object deleting
    */
    override func prepareForDeletion() {
        super.prepareForDeletion()
        
        CacheForMemory.remove(self.filePath)
        CacheForFile.remove(self.filePath)
    }
}