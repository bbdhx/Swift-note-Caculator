//
//  Line.swift
//  Calculator_01
//
//  Created by mac1014 on 2021/2/17.
//  Copyright © 2021 Kong. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

class Line: NSObject, NSCoding {
    var begin = CGPoint.zero
    var end = CGPoint.zero
    
    var lineWidth: CGFloat = 3
    var lineColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    
    var lineType: String? = nil
    
    override init() {
        
    }
    
    init(begin: CGPoint, end: CGPoint, lineWidth: CGFloat, lineColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), lineType: String? = nil)
    {
        self.begin = begin
        self.end = end
        self.lineWidth = lineWidth
        self.lineColor = lineColor
        self.lineType = lineType
    }
    
    // MARK: - 1 - encode
    func encode(with coder: NSCoder) {
        coder.encode(begin, forKey: "begin")
        coder.encode(end, forKey: "end")
        coder.encode(lineWidth, forKey: "lineWidth")
        coder.encode(lineColor, forKey: "lineColor")
        coder.encode(lineType, forKey: "lineType")
    }

    // MARK: - 2 - decode
    required init?(coder: NSCoder) {
        begin = coder.decodeCGPoint(forKey: "begin")
        end = coder.decodeCGPoint(forKey: "end")
        lineWidth = coder.decodeObject(forKey: "lineWidth") as! CGFloat
        lineColor = coder.decodeObject(forKey: "lineColor") as! UIColor
        lineType = coder.decodeObject(forKey: "lineType") as? String
    }
}
