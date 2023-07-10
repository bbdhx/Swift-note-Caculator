//
//  EllipseTool.swift
//  Calculator_01
//
//  Created by mac1014 on 2021/2/18.
//  Copyright © 2021 Kong. All rights reserved.
//

import Foundation
import UIKit

class EllipseTool: BaseTool {
    override func stroke(_ line: Line) {
        let rect = CGRect(
            x: min(line.begin.x, line.end.x),
            y: min(line.begin.y, line.end.y),
            width: abs(line.end.x - line.begin.x),
            height: abs(line.end.y - line.begin.y)
        )
        let cornerRadius = min(rect.width / 2, rect.height / 2)
        
        //roundedRect
        line.lineColor.setStroke()
        let path = UIBezierPath.init(roundedRect: rect, cornerRadius: cornerRadius)
        path.lineWidth = line.lineWidth
        //oval
//        let path = UIBezierPath.init(ovalIn: rect)
        path.stroke()
    }
}
