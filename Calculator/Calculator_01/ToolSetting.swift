//
//  ToolSetting.swift
//  Calculator_01
//
//  Created by mac1014 on 2021/2/25.
//  Copyright © 2021 Kong. All rights reserved.
//

import Foundation
import UIKit

class ToolSetting: NSObject, NSCoding {
    var backgroundColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 0.9658872003, alpha: 1)
    
    let toolSettingArchiveURL: URL = {
        let documentsDirectories
            = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("toolSetting.archive")
    }()
    
    func encode(with coder: NSCoder)
    {
        coder.encode(backgroundColor, forKey: "backgroundColor")
    }
    
    required init?(coder: NSCoder) {
        backgroundColor = coder.decodeObject(forKey: "backgroundColor") as! UIColor
        
        super.init()
    }
    
    override init() {
        if let archivedToolSetting = NSKeyedUnarchiver.unarchiveObject(withFile: toolSettingArchiveURL.path) as? UIColor {
            backgroundColor = archivedToolSetting
        }
    }
    
    func saveChanges() -> Bool {
        print("Saving items to: \(toolSettingArchiveURL.path)")
        return NSKeyedArchiver.archiveRootObject(backgroundColor, toFile: toolSettingArchiveURL.path)
    }
    
}
