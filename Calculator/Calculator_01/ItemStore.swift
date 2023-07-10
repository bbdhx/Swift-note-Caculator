//
//  ItemStore.swift
//  Calculator_01
//
//  Created by mac1014 on 2021/2/16.
//  Copyright © 2021 Kong. All rights reserved.
//

import UIKit

class ItemStore {
    var allItems = [Item]()
    
    var toolSetting: ToolSetting? = nil
    
    // MARK: - 3. get item save url
    let itemArchiveURL: URL = {
        let documentsDirectories
            = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("items.archive")
    }()
    
    // MARK: - 6. init from archive
    init() {
        if let archivedItems = NSKeyedUnarchiver.unarchiveObject(withFile: itemArchiveURL.path) as? [Item] {
            allItems = archivedItems
        }
    }
    
    // MARK: - 4. archive item
    @discardableResult func saveChanges() -> Bool {
        print("Saving items to: \(itemArchiveURL.path)")
        return NSKeyedArchiver.archiveRootObject(allItems, toFile: itemArchiveURL.path)
    }
    
    // MARK: - creat a new item
    @discardableResult func creat() -> Item
    {
        let newItem = Item(title: "\(Date())", drawViewBackgroundColor: toolSetting!.backgroundColor)
        allItems.append(newItem)
        
        return newItem
    }
    
    // MARK: - removeItem
    func removeItem(_ item: Item) {
        if let index = allItems.firstIndex(of: item)
        {
            allItems.remove(at: index)
        }
    }
    
    // MARK: - moveItem
    func moveItem(from fromIndex: Int, to toIndex: Int) {
        if fromIndex == toIndex
        {
            return
        }
        
        // Get the reference to object being moved so you can reinsert it
        let movedItem = allItems[fromIndex]
        
        // Remove item from array
        allItems.remove(at: fromIndex)
        
        // Insert item in array at new location
        allItems.insert(movedItem, at: toIndex)
    }
}
