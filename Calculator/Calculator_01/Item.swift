//
//  Item.swift
//  Calculator_01
//
//  Created by mac1014 on 2021/2/16.
//  Copyright © 2021 Kong. All rights reserved.
//

import UIKit

class Item: NSObject, NSCoding {
    
    // MARK: - table display
    var title: String
    let dateCreat: Date
    let itemKey: String
    
    // MARK: - drawView lines
    lazy var lineStore = [
        PencilLineStore(url:get()),
        RulerLineStore(url:get()),
        RectangleLineStore(url:get()),
        EllipseLineStore(url:get()),
        TriangleLineStore(url: get()),
        EraserLineStore(url: get())
    ]
    
    lazy var allLineWithSort = AllineWithSort(url: get())
    
//    // MARK: - drawView Images
//    var imageStore: ImageStore!
    
    // MARK: - draw view itself property
    var drawViewBackgroundColor: UIColor? = nil
    
    // MARK: - get item save url
    func get() -> String
    {
        return "\(dateCreat)"
    }
    
    // MARK: - init
    init(title: String, drawViewBackgroundColor: UIColor)
    {
        self.title = title
        self.dateCreat = Date()
        self.drawViewBackgroundColor = drawViewBackgroundColor
        self.itemKey = UUID().uuidString
        super.init()
    }

    // MARK: - 2. decode
    required init?(coder: NSCoder)
    {
        title = coder.decodeObject(forKey: "title") as! String
        dateCreat = coder.decodeObject(forKey: "dateCreat") as! Date
        drawViewBackgroundColor = coder.decodeObject(forKey: "drawViewBackgroundColor") as? UIColor
        itemKey = coder.decodeObject(forKey: "itemKey") as! String
        super.init()
    }
    
    // MARK: - 1. encode
    func encode(with coder: NSCoder)
    {
        coder.encode(title, forKey: "title")
        coder.encode(dateCreat, forKey: "dateCreat")
        coder.encode(drawViewBackgroundColor, forKey: "drawViewBackgroundColor")
        coder.encode(itemKey, forKey: "itemKey")
        
        print("items save")
        for i in 0..<lineStore.count
        {
            print("items - save - \(i)-line")
            lineStore[i].saveChanges()
        }
        allLineWithSort.saveChanges()
    }
}
