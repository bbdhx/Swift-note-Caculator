//
//  Image.swift
//  Calculator_01
//
//  Created by mac1014 on 2021/3/6.
//  Copyright © 2021 Kong. All rights reserved.
//

//import Foundation
import UIKit

class Image: NSObject, NSCoding {
//    var image = [String: UIImage]()
    let cache = NSCache<NSString, UIImage>()
    var keyStore = [String]()
    var position = [String : CGPoint]()
    var widthAndHeight = [String : CGSize]()
    
    func setImage(_ image: UIImage, forKey key: String, in position: CGPoint, with widthAndHeight: CGSize) {
        cache.setObject(image, forKey: key as NSString)
        
        let url = imageURL(forKey: key)
        if let data = image.jpegData(compressionQuality: 0.5) {
            let _ = try? data.write(to: url, options: [.atomic])
        }
        
        
        self.keyStore.append(key)
        self.position[key] = position
        self.widthAndHeight[key] = widthAndHeight
    }
    
    func getImageAndPosition(forKey key: String) -> (UIImage?, CGPoint?) {
        let position = self.position[key]
        if let existingImage = cache.object(forKey: key as NSString) {
            return (existingImage, position)
        }
        
        let url = imageURL(forKey: key)
        guard let imageFromDisk = UIImage(contentsOfFile: url.path) else {
            return (nil, nil)
        }
        
        cache.setObject(imageFromDisk, forKey: key as NSString)
        return (imageFromDisk, position)
    }
    
    func getWidthAndHeightForImage(withKey key: String) -> CGSize? {
        let widthAndHeight = self.widthAndHeight[key]
        if widthAndHeight != nil {
            return widthAndHeight
        } else {
            return nil
        }
    }
    
    func deleteImage(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
        let url = imageURL(forKey: key)
        do {
            try FileManager.default.removeItem(at: url)
        } catch let deleteError {
            print("Error removing the image from disk: \(deleteError)")
        }
        
        keyStore.remove(at: keyStore.firstIndex(of: key)!)
        self.position[key] = nil
        self.widthAndHeight[key] = nil
    }
    
    func panPhoto(forKey key: String, with translation: CGPoint) {
        let oldPosition = self.position[key]
        let x = oldPosition!.x + translation.x
        let y = oldPosition!.y + translation.y
        self.position[key] = CGPoint(x: x, y: y)
    }
    
    func pinchPhoto(forKey key: String, with newWidthAndHeight: CGSize) {
        let oldWidthAndHeight = self.widthAndHeight[key]
        let w = newWidthAndHeight.width - oldWidthAndHeight!.width
        let h = newWidthAndHeight.height - oldWidthAndHeight!.height
        let oldPosition = self.position[key]
        let x = oldPosition!.x - w / 2
        let y = oldPosition!.y - h / 2
        self.position[key] = CGPoint(x: x, y: y)
        self.widthAndHeight[key] = newWidthAndHeight
        print(newWidthAndHeight)
    }
    
    func imageURL(forKey key: String) -> URL {
        let documentsDirectories
            = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent(key)
        
    }
    
    override init() {
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(keyStore, forKey: "keyStore")
        coder.encode(position, forKey: "position")
        coder.encode(widthAndHeight, forKey: "widthAndHeight")
    }
    
    required init?(coder: NSCoder) {
        keyStore = coder.decodeObject(forKey: "keyStore") as! [String]
        position = coder.decodeObject(forKey: "position") as! [String : CGPoint]
        widthAndHeight = coder.decodeObject(forKey: "widthAndHeight") as! [String : CGSize]
    }
    
    
}

