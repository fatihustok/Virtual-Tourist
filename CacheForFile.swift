//
//  FileCache.swift
//  Virtual_Tourist_FatihUstok
//
//  Created by Refik Fatih Ustok on 20/05/16.
//  Copyright © 2016 Refik Fatih Ustok. All rights reserved.
//
import UIKit

class FileCache {
    
    static private let shared = FileCache()
    
    // Getter for images
    static func get(forPath: String) -> UIImage? {
        return UIImage(contentsOfFile: forPath)
    }
    
    // Setter for images
    static func set(data: UIImage, forPath: String) {
        UIImagePNGRepresentation(data)!.writeToFile(forPath, atomically: true)
        print("Photo file created \(forPath)")
    }
    
    // Remover
    static func remove(forPath: String) {
        if NSFileManager.defaultManager().fileExistsAtPath(forPath) {
            do {
                try NSFileManager.defaultManager().removeItemAtPath(forPath)
                print("Photo file removed")
            } catch { }
        }
    }
}
