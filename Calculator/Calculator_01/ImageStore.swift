//
//  ImageStore.swift
//  Calculator_01
//
//  Created by mac1014 on 2021/3/6.
//  Copyright © 2021 Kong. All rights reserved.
//

//import Foundation
import UIKit

class ImageStore {
    var allImageStore = [String : Image]()
    
    init() {
        if let archivedAllImageStore = NSKeyedUnarchiver.unarchiveObject(withFile: imageKeyAndPositionArchiveURL().path) as? [String : Image] {
            allImageStore = archivedAllImageStore
        }
    }
    
    func imageKeyAndPositionArchiveURL() -> URL
    {
        let documentsDirectories
            = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("imageKeyAndPosition.archive")
    }
    
    @discardableResult func saveChanges() -> Bool {
        print("Saving items to: \(imageKeyAndPositionArchiveURL().path)")
        return NSKeyedArchiver.archiveRootObject(allImageStore, toFile: imageKeyAndPositionArchiveURL().path)
    }
}
