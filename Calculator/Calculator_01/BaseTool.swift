//
//  BaseTool.swift
//  Calculator_01
//
//  Created by mac1014 on 2021/2/18.
//  Copyright © 2021 Kong. All rights reserved.
//

import Foundation
import UIKit

// Pencil, Ruler, Rectangle, Ellipse, Eraser

class BaseTool {
    
    var numberOfMove: Int = 0
    
    func stroke(_ line: Line)
    {
        line.lineColor.setStroke()
        let path = UIBezierPath()
        path.lineWidth = line.lineWidth
        path.lineCapStyle = .round
        path.lineJoinStyle = .round
        
        path.move(to: line.begin)
        path.addLine(to: line.end)
        path.stroke()
    }
    
    func lineMoveStyle(_ touches: Set<UITouch>, in view: UIView, with lineStore: LineStore, andStyle: String, allLineStore: LineStore)
    {
        let touch = touches.first!
        let location = touch.location(in: view)

        lineStore.currentLine?.end = location
    }
    
    func lineEndStyle(_ touches: Set<UITouch>, in view: UIView, with lineStore: LineStore, allLineStore: LineStore)
    {
        if let line = lineStore.currentLine
        {
            let touch = touches.first!
            let location = touch.location(in: view)
            line.end = location

            lineStore.finishedLines.append(line)
            allLineStore.finishedLines.append(line)
            
        }
    }
}
