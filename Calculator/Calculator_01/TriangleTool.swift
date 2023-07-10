//
//  TriangleTool.swift
//  Calculator_01
//
//  Created by mac1014 on 2021/3/2.
//  Copyright © 2021 Kong. All rights reserved.
//

import Foundation
import UIKit

class TriangleTool: BaseTool {
    override func stroke(_ line: Line) {
        
        let upPointX = (line.begin.x + line.end.x) / 2
        let upPointY = min(line.begin.y, line.end.y)
        let upPoint = CGPoint(x: upPointX, y: upPointY)
        let downPoint1X = max(line.begin.x, line.end.x)
        let downPoint1Y = max(line.begin.y, line.end.y)
        let downPoint1 = CGPoint(x: downPoint1X, y: downPoint1Y)
        let downPoint2X = min(line.begin.x, line.end.x)
        let downPoint2Y = max(line.begin.y, line.end.y)
        let downPoint2 = CGPoint(x: downPoint2X, y: downPoint2Y)
        
        
        line.lineColor.setStroke()
        let path = UIBezierPath()
        path.lineCapStyle = .round
        path.lineJoinStyle = .round
        path.lineWidth = line.lineWidth
        path.move(to: upPoint)
        path.addLine(to: downPoint1)
        path.addLine(to: downPoint2)
        path.close()
        
        path.stroke()
    }
}
