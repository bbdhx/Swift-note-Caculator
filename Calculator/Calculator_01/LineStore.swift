//
//  LineStore.swift
//  Calculator_01
//
//  Created by mac1014 on 2021/2/18.
//  Copyright © 2021 Kong. All rights reserved.
//

import Foundation
let fileName = "lineStore"
class LineStore {
    
    // MARK: -
    var currentLine: Line?
    var finishedLines = [Line]()
    
    // MARK: - 3 - Archive URL
    let url: String
    func ArchiveURL() -> URL
    {
        let documentsDirectories
            = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("\(url).archive")
    }
    
    // MARK: - 6 - init to unarchive
    init(url: String) {
        self.url = url
        if let archivedLines =
            NSKeyedUnarchiver.unarchiveObject(withFile: ArchiveURL().path) as? [Line] {
            finishedLines = archivedLines
            
            print("init from archive")
        } else {
            print("lines init")
        }
    }
    
    // MARK: - 4 - save to archive
    @discardableResult func saveChanges() -> Bool {
        print("Saving items to: \(ArchiveURL().path)")
        return NSKeyedArchiver.archiveRootObject(finishedLines, toFile: ArchiveURL().path)
    }
}

// MARK: - PencilLineStore
class PencilLineStore: LineStore {
    override func ArchiveURL() -> URL
    {
        let documentsDirectories
            = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("\(url)Pencile.archive")
    }
}

// MARK: - RulerLineStore
class RulerLineStore: LineStore {
    override func ArchiveURL() -> URL
    {
        let documentsDirectories
            = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("\(url)Ruler.archive")
    }
}

// MARK: - RectangleLineStore
class RectangleLineStore: LineStore {
    override func ArchiveURL() -> URL
    {
        let documentsDirectories
            = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("\(url)Rectangle.archive")
    }
}

// MARK: - EllipseLineStore
class EllipseLineStore: LineStore {
    override func ArchiveURL() -> URL
    {
        let documentsDirectories
            = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("\(url)Ellipse.archive")
    }
}

// MARK: - Eraser
class EraserLineStore: LineStore {
    override func ArchiveURL() -> URL {
        let documentsDirectories
            = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("\(url)Eraser.archive")
    }
}

// MAEK: - Triangle
class TriangleLineStore: LineStore {
    override func ArchiveURL() -> URL {
        let documentsDirectories
            = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("\(url)Triangle.archive")
    }
}

// MARK: - AllineWithSort
class AllineWithSort: LineStore {
    override func ArchiveURL() -> URL {
        let documentsDirectories
            = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("\(url)AllineWithSort.archive")
    }
}
