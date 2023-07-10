//
//  EraserTool.swift
//  Calculator_01
//
//  Created by mac1014 on 2021/3/2.
//  Copyright © 2021 Kong. All rights reserved.
//

import Foundation
import UIKit

class EraserTool: BaseTool {
    
    var color: UIColor? = nil
    
    override func stroke(_ line: Line)
    {
        line.lineColor.setStroke()
//        color?.setStroke()
        let path = UIBezierPath()
        path.lineWidth = line.lineWidth
        path.lineCapStyle = .round
        path.lineJoinStyle = .round
        
        path.move(to: line.begin)
        path.addLine(to: line.end)
        path.stroke()
    }
    
    override func lineMoveStyle(_ touches: Set<UITouch>, in view: UIView, with lineStore: LineStore, andStyle: String, allLineStore: LineStore) {
        
        let line = Line(
            begin: (lineStore.currentLine?.begin)!,
            end: (lineStore.currentLine?.end)!,
            lineWidth: (lineStore.currentLine?.lineWidth)!,
            lineColor: (lineStore.currentLine?.lineColor)!,
            lineType: andStyle
        )
        
        let location = touches.first!.location(in: view)
        line.end = location
        
        lineStore.finishedLines.append(line)
        allLineStore.finishedLines.append(line)
        
        lineStore.currentLine?.begin = location
        lineStore.currentLine?.end = location
    }
}
