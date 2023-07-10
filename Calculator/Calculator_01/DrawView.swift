//
//  DrawView.swift
//  Calculator_01
//
//  Created by mac1014 on 2021/2/17.
//  Copyright © 2021 Kong. All rights reserved.
//

import UIKit

//@IBDesignable
class DrawView: UIView, UITextViewDelegate {
    //MARK: - item key
    var itemKey: String!
    
    //MARK: - image properties
    var imagePoint: CGPoint = .zero
    var image: Image!
    
    //MARK: - text view properties
    var textViewPoint: CGPoint = .zero
    var textView: TextView!
    
    //MARK: - line properties
    var lineWidth: CGFloat = 3
    var lineColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    
    var bool = true
    
    //MARK: - tool set
    let toolKit = [PencilTool() , RulerTool(), RectangleTool(), EllipseTool(), TriangleTool(), EraserTool()]
//    var lineStoreKit = [PencilLineStore(), RulerLineStore(), RectangleLineStore(), EllipseLineStore()...]
    var lineStoreKit:[LineStore]!
    
    var allLineWithStyle: LineStore!
    // 0: Pencil, 1: RUler, 2: Rectangle, 3: Ellipse, 4: Triangle, 5: Eraser
    var lineType: String = "0"

    lazy var tool: BaseTool = toolKit[0]
    lazy var lineStore = lineStoreKit[0]
    
    var withdrawLine = [Line]()
    
    // MARK: - refresh view
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // draw image once
        if bool {
            drawImage()
            bool = false
        }
        
        // refresh line
        setNeedsDisplay()
    }
    
    //MARK: - loop for all line
    override func draw(_ rect: CGRect) {
        /* - stroke with tool
        for index in 0..<toolKit.count {
            let tool = toolKit[index]
            let lineStore = lineStoreKit[index]
            for line in lineStore.finishedLines {
                tool.stroke(line)
            }
        }

        if let line = lineStore.currentLine {
            tool.stroke(line)
        }
        */

        var firstLine: Line?
        var centerPoint: CGPoint?
        for line in allLineWithStyle.finishedLines {
            let index = Int(line.lineType!)!
            let tool = toolKit[index]
            if index != 0 {
                tool.stroke(line)
                firstLine = nil
                centerPoint = nil
            }
            else {
                if firstLine == nil {
                    firstLine = line
                    continue
                } else {
                    (tool as! PencilTool).stroke(&firstLine, line, &centerPoint)
                }
            }
        }
        if let line = lineStore.currentLine {
            tool.stroke(line)
        }
    }
    
    //MARK: - touchesBegan(_: with:)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.endEditing(true)
        
        //Get location of the touch in the view's coordinate system
        let touch = touches.first!
        let location = touch.location(in: self)
        
        let line = Line(begin: location, end: location, lineWidth: lineWidth, lineColor: lineColor, lineType: lineType)
        lineStore.currentLine = line
        
        if tool is PencilTool {
            tool.numberOfMove = 0
        }
        
        print("began")
        setNeedsDisplay()
    }
    
    //MARK: - touchesMoved(_: with:)
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (UIMenuController.shared.isMenuVisible) {
            UIMenuController.shared.hideMenu(from: self)
        }
        if tool is PencilTool {
            tool.numberOfMove = tool.numberOfMove + 1
        }
        tool.lineMoveStyle(touches, in: self, with: lineStore, andStyle: lineType, allLineStore: allLineWithStyle)

        print("move")
        setNeedsDisplay()
    }
    
    //MARK: - touchesEnded(_: with:)
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if tool is PencilTool{
            tool.numberOfMove = 0
        }
        
        tool.lineEndStyle(touches, in: self, with: lineStore, allLineStore: allLineWithStyle)
        lineStore.currentLine = nil
        print("end")
        setNeedsDisplay()
    }
    
    //MARK: - touchesCancelled(_: with:)
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("cancel")
        lineStore.currentLine = nil
        if tool is PencilTool, tool.numberOfMove != 0 {
            for _ in 0..<tool.numberOfMove {
                lineStore.finishedLines.removeLast()
                allLineWithStyle.finishedLines.removeLast()
            }
            tool.numberOfMove = 0
        }
        setNeedsDisplay()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    // MARK: - can become first responder for menuController
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func drawImage() {
//        for (key, image) in self.image.image
//        {
//            let position = self.image.position[key]
////            //MARK: get image view for show image
//            let imageView: UIImageView = UIImageView(frame: CGRect(x: position!.x, y: position!.y, width: self.frame.width / 2, height: self.frame.height / 4))
////            // MARK: set image mode
//            imageView.contentMode = .scaleAspectFit
////            // MARK: add image in image view
//            imageView.image = image
////            // MARK: add image view in draw view
//            addSubview(imageView)
//        }
        for key in self.image.keyStore {
            let (image, position) = self.image.getImageAndPosition(forKey: key)
//            print(position!)
            let widthAndHeight = self.image.getWidthAndHeightForImage(withKey: key)
            let imageView: UIImageView = UIImageView(
                frame: CGRect(x: position!.x,
                              y: position!.y,
                              width: widthAndHeight!.width,
                              height: widthAndHeight!.height))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
//            imageView.backgroundColor = .blue
            imageView.accessibilityIdentifier = key
            addSubview(imageView)
        }
        
        for key in self.textView.textKeyStore {
            let (text, position) = self.textView.getTextAndPosition(forKey: key)
        //            print(position!)
            let widthAndHeight = self.textView.getWidthAndHeightForText(withKey: key)
            let textView: UITextView = UITextView(
                frame: CGRect(x: position!.x,
                              y: position!.y,
                              width: widthAndHeight!.width,
                              height: widthAndHeight!.height))
            textView.layer.borderWidth = 1
            textView.layer.borderColor = UIColor.gray.cgColor
            textView.textColor = .black
            textView.backgroundColor = .none
    
            textView.text = text
            
            textView.accessibilityIdentifier = key
            
            textView.delegate = self
    
            addSubview(textView)
        }
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        print("text view did change")
        
        saveNewText(to: textView)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("text view did end editing")
        
        saveNewText(to: textView)
    }
    
    func saveNewText(to textView: UITextView) {
        let textViewKey = textView.accessibilityIdentifier
        let newText = textView.text
        self.textView.setText(forKey: textViewKey!, with: newText!)
    }
    
    lazy var width = self.frame.width
    lazy var height = self.frame.height
}

