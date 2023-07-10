//
//  PencilTool.swift
//  Calculator_01
//
//  Created by mac1014 on 2021/2/18.
//  Copyright © 2021 Kong. All rights reserved.
//

import Foundation
import UIKit

class PencilTool: BaseTool {
    
    func stroke(_ lineOne: inout Line?, _ lineTwo: Line, _ centerPoint: inout CGPoint?)
    {
        lineOne!.lineColor.setStroke()
        let path = UIBezierPath()
        path.lineWidth = lineOne!.lineWidth
        path.lineCapStyle = .round
        path.lineJoinStyle = .round
        
        
        
        if lineOne!.end == lineTwo.begin {
            let nextCenterPoint = CGPoint(x: (lineOne!.end.x + lineTwo.end.x) / 2, y: (lineOne!.end.y + lineTwo.end.y) / 2)
            if centerPoint == nil {
                path.move(to: lineOne!.begin)
                path.addQuadCurve(to: nextCenterPoint, controlPoint: lineOne!.end)
                centerPoint = nextCenterPoint
            } else {
                path.move(to: centerPoint!)
                path.addQuadCurve(to: nextCenterPoint, controlPoint: lineOne!.end)
                centerPoint = nextCenterPoint
            }
            lineOne = lineTwo
            print("QuadCurve")
        } else {
            centerPoint = nil
//            lineOne = nil
//            path.move(to: lineOne.begin)
//            path.addLine(to: lineOne.end)
            if lineTwo.begin == lineTwo.end {
                path.move(to: lineTwo.begin)
                path.addLine(to: lineTwo.end)
            }
            print("Curve")
        }
        lineOne = lineTwo

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
