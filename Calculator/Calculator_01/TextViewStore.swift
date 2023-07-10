//
//  TextViewStore.swift
//  Calculator_01
//
//  Created by mac1014 on 2021/4/12.
//  Copyright © 2021 Kong. All rights reserved.
//

//import Foundation
import UIKit

class TextViewStore {
    var allTextViewStore = [String : TextView]()
    
    func textViewKeyAndPositionArchiveURL() -> URL
    {
        let documentsDirectories
            = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("textViewKeyAndPosition.archive")
    }
    
    init() {
        if let archivedAllTextViewStore = NSKeyedUnarchiver.unarchiveObject(withFile: textViewKeyAndPositionArchiveURL().path) as? [String : TextView] {
            allTextViewStore = archivedAllTextViewStore
        }
    }
    
    @discardableResult func saveChanges() -> Bool {
        print("Saving items to: \(textViewKeyAndPositionArchiveURL().path)")
        return NSKeyedArchiver.archiveRootObject(allTextViewStore, toFile: textViewKeyAndPositionArchiveURL().path)
    }
}
