//
//  FunctionDraw.swift
//  Calculator_01
//
//  Created by mac1014 on 2021/4/13.
//  Copyright © 2021 Kong. All rights reserved.
//

//import Foundation
import UIKit

class FunctionDraw: UIView {

    private var function: ((CGFloat) -> CGFloat)? //一元函数

    override func draw(_ rect: CGRect) {
        //调用父类的draw方法
        super.draw(rect)

        //创建一个UIBezierPath变量，UIBezierPath可创建基于矢量的路径，常用来绘图
        let rectPath = UIBezierPath(rect: rect)
        //设置白色填充
        UIColor.gray.setFill()
        //先将MyView填充一层色
        rectPath.fill()

        //再创建一个UIBezierPath变量，用于绘制坐标系
        let path = UIBezierPath()
        //坐标系用红色描边
        UIColor.black.setStroke()
        //坐标系以MyView中心为原点，向右为x正方向，向上为y正方向
        //先将path移动到左边线中点处
        path.move(to: CGPoint(x: 0, y: rect.height / 2))
        //然后添加一条到右边线中点处的直线
        path.addLine(to: CGPoint(x: rect.width, y: rect.height / 2))
        //绘制这条直线
        path.stroke()
        //这样就完成了x轴的绘制

        //绘制y轴原理同上
        path.move(to: CGPoint(x: rect.width / 2, y: 0))
        path.addLine(to: CGPoint(x: rect.width / 2, y: rect.height))
        path.stroke()

        //判断函数是否为空，方便后面会再次调用draw函数
        if function != nil {
            let path = curve(rect: rect, color: UIColor.red, function: function!)
            path.stroke()
        }
    }


    /// 绘制图形的函数
    ///
    /// - Parameter function: 需要绘制的一元函数
    func drawCurve(function: @escaping (CGFloat) -> CGFloat) {
        self.function = function
        self.draw(self.frame)
    }


    /// 计算函数绘制的路径
    ///
    /// - Parameters:
    ///   - rect: 绘制区域
    ///   - color: 绘制函数的颜色
    ///   - function: 需要绘制的函数
    /// - Returns: 返回最终绘制的路径
    private func curve(rect: CGRect, color: UIColor, function: (CGFloat) -> CGFloat) -> UIBezierPath {
        let path = UIBezierPath()

        //该绘制区域的宽度的一半
        let center = rect.width / 2
        //y轴的高度的一半
        let height = rect.height / 2
        //需要计算多少个x值对应的y值（x轴正半轴）
        let rate: CGFloat = 100
        color.setStroke()

        //从原点开始，先计算x轴正半轴的所有y值
        path.move(to: CGPoint(x: center, y: height - function(0)))
        //stride为步进函数，设置起始值、结尾值和步进值
        for item in stride(from: center / rate, through: center, by: center / rate) {
            path.addLine(to: CGPoint(x: center + item, y: height - function(item)))
        }
        //因为自己建立的简易坐标系与UIView视图默认的坐标系不同(UIView默认视图坐标系原点在左上角，并向右为x轴正方向，向下为y轴正方向)。
        //所以需要用到类似仿射变换的方式转换坐标系，将当前坐标系中的点转换成UIView坐标系中的值。
        //UIView中x值为当前值加上x轴宽度的一半，y值为y轴高度的一半减去在当前坐标系中的y值

        //绘制x轴负半轴的所有y值，原理类似
        path.move(to: CGPoint(x: center, y: height - function(0)))
        for item in stride(from: center / rate, through: center, by: center / rate) {
            path.addLine(to: CGPoint(x: center - item, y: height - function(-item)))
        }

        return path
    }

}
