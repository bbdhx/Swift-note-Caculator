//
//  RectangleTool.swift
//  Calculator_01
//
//  Created by mac1014 on 2021/2/18.
//  Copyright © 2021 Kong. All rights reserved.
//

import Foundation
import UIKit

class RectangleTool: BaseTool {
    override func stroke(_ line: Line) {
        let rect = CGRect(
            x: min(line.begin.x, line.end.x),
            y: min(line.begin.y, line.end.y),
            width: abs(line.end.x - line.begin.x),
            height: abs(line.end.y - line.begin.y)
        )
        
        line.lineColor.setStroke()
        let path = UIBezierPath(rect: rect)
        path.lineWidth = line.lineWidth
        path.stroke()
    }
    
//    override func lineShape(_ touches: Set<UITouch>, in view: UIView, with lineStore: LineStore)
//    {
//        if var line = lineStore.currentLine
//                {
//                    let touch = touches.first!
//                    let location = touch.location(in: view)
//                    let begin = line.begin
//
//                    //(b.x, b.y)         (l.x, b.y)
//                    //
//                    //(b.x, l.y)         (l.x, l.y)
//
//                    line.end = CGPoint(x: line.begin.x, y: location.y)
//                    lineStore.finishedLines.append(line)
//                    line.end = CGPoint(x: location.x, y: line.begin.y)
//                    lineStore.finishedLines.append(line)
//
//                    line.end = location
//                    line.begin = CGPoint(x: begin.x, y: location.y)
//                    lineStore.finishedLines.append(line)
//                    line.begin = CGPoint(x: location.x, y: begin.y)
//                    lineStore.finishedLines.append(line)
//                }
//    }
}
