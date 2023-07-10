//
//  TextView.swift
//  Calculator_01
//
//  Created by mac1014 on 2021/4/12.
//  Copyright © 2021 Kong. All rights reserved.
//

//import Foundation
import UIKit

class TextView: NSObject, NSCoding {
    var text = [String : String]()
    var textKeyStore = [String]()
    var position = [String : CGPoint]()
    var widthAndHeight = [String : CGSize]()
    
    func setText(forKey key: String, in position: CGPoint, with widthAndHeight: CGSize) {
        
        self.textKeyStore.append(key)
        self.position[key] = position
        self.widthAndHeight[key] = widthAndHeight
    }
    
    func getTextAndPosition(forKey key: String) -> (String?, CGPoint?) {
        let position = self.position[key]
        let text = self.text[key]
        
        return (text, position)
    }
    
    func getWidthAndHeightForText(withKey key: String) -> CGSize? {
        let widthAndHeight = self.widthAndHeight[key]
        
        return widthAndHeight
    }
    
    func deleteTextView(forKey key: String) {
        self.text[key] = nil
        self.textKeyStore.remove(at: self.textKeyStore.firstIndex(of: key)!)
        self.position[key] = nil
        self.widthAndHeight[key] = nil
    }
    
    func panTextView(forKey key: String, with translation: CGPoint) {
        let oldPosition = self.position[key]
        let x = oldPosition!.x + translation.x
        let y = oldPosition!.y + translation.y
        self.position[key] = CGPoint(x: x, y: y)
    }
    
    func setText(forKey key: String, with newText: String) {
        self.text[key] = newText
    }
    
//    func textViewURL(forKey key: String) -> URL {
//        let documentsDirectories
//            = FileManager.default.urls(
//                for: .documentDirectory,
//                in: .userDomainMask)
//        let documentDirectory = documentsDirectories.first!
//        return documentDirectory.appendingPathComponent(key)
//
//    }
    
    override init() {
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(text, forKey: "text")
        coder.encode(textKeyStore, forKey: "textKeyStore")
        coder.encode(position, forKey: "position")
        coder.encode(widthAndHeight, forKey: "widthAndHeight")
    }
    
    required init?(coder: NSCoder) {
        text = coder.decodeObject(forKey: "text") as! [String : String]
        textKeyStore = coder.decodeObject(forKey: "textKeyStore") as! [String]
        position = coder.decodeObject(forKey: "position") as! [String : CGPoint]
        widthAndHeight = coder.decodeObject(forKey: "widthAndHeight") as! [String : CGSize]
    }
}
