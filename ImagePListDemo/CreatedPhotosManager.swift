//
//  CreatedPhotosManager.swift
//  Drememe
//
//  Created by John Jin Woong Kim on 2/25/17.
//  Copyright © 2017 John Jin Woong Kim. All rights reserved.
//

import Foundation
import UIKit
class PhotoNode{
    var path: String
    var orgImage: UIImage
    var dictionary:NSDictionary
    
    init(path: String, o:UIImage, dic:NSDictionary) {
        self.path = path
        self.orgImage = o
        self.dictionary = dic
    }
    
    deinit {
        print("PhotoNode deinitialized with path ", path)
    }
}

class CreatedPhotosManager{
    // Decided to just make a manager for the created photos due to their
    //  awkward situation of requiring not only the pre made static plists
    //  but also requiring a filesystem manager as well to read/write/edit
    //  existing mutable directories, unlike the blank templates which
    //  will remain static and unlike the favorites photos, which only
    //  require a plist manager to hold indexes of templates that have been
    //  saved.
    
    //i realize how silly it is to just use incrementing numbers
    // for the pathnames of the images, but reallly it is the simplest form
    // to use as well as the easiest generator of unique key names
    var photos = [PhotoNode]()
    init() {
        self.photos = allCreatedPaths()
        for p in self.photos{
            print("Init CreatedPhotosManager ", p.path)
        }

    }
    
    class func allCreated() -> [Int]{
        var favs = [Int]()
        let dictionary = PlistManager.sharedInstance.getPlist()
        for val in dictionary.allValues{
            favs.append((val as? Int)!)
            print((val as? Int)!)
        }
        return favs
    }
    
    func allCreatedPaths() -> [PhotoNode]{
        var pn = [PhotoNode]()
        let dictionary = PlistManager.sharedInstance.getPlist()
        
        for key in dictionary.allKeys{
            if let path = key as? String{
                let image = FileSystemManager.sharedInstance.getImage(name: path+".jpg")
                if let dict = dictionary.value(forKey: path) as? NSDictionary{
                    pn.append(PhotoNode(path: path, o: image, dic: dict))
                }
            }
        }
        return pn
    }

    
    func getOriginalImage(index: Int) ->UIImage {
        return self.photos[index].orgImage
    }
    
    func getAnnotatedImage(index: Int) -> UIImage {
        return self.photos[index].orgImage
    }
    
    func getPath(index: Int) -> String{
        return self.photos[index].path
    }
    
    func getCount() -> Int{
        return photos.count
    }
    
    func getIndexForValue(path:String) -> Int{
        for p in 0...photos.count{
            if photos[p].path == path{
                return p
            }
        }
        return -1
    }
    
    
    func addNewCreated(path:String, image: UIImage, dic:NSDictionary){
        let node = PhotoNode(path:path, o: image, dic: dic)
        PlistManager.sharedInstance.addNewItemWithKey(key: node.path, value: dic)
        FileSystemManager.sharedInstance.saveImageDocumentDirectory(image: image, name: node.path+".jpg")
        print("number of photos in CreatedPhotoManager ", photos.count)
        for p in photos{
            print( p.path)
        }
        print("Saving new created image with path ", node.path )
        photos.append(node)
    }
    
    func removeCreated(path:String) -> Bool{
        print("CreatedPhotosManager:: ")
        PlistManager.sharedInstance.removeItemForKey(key: path)
        print("    removeItemForKey() done")
        FileSystemManager.sharedInstance.removeImage(name: path+".jpg")
        print("    removeImage() done")
        let index = getIndexForValue(path: path)
        if index != -1{
            print("   removed created photo with path ", path)
            self.photos.remove(at: index)
            return true
        }else{
            print("   could not find created photo with path ", path)
            return false
        }
        
    }
    
}
