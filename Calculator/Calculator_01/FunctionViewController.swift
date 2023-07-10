//
//  FunctionViewController.swift
//  Calculator_01
//
//  Created by mac1014 on 2021/4/14.
//  Copyright © 2021 Kong. All rights reserved.
//

import UIKit

class FunctionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        updateView()
        
        //functionDraw(x: CGFloat(result))
    }
    
    
    @IBOutlet weak var FunctionLabel: UILabel!
    @IBAction func FunctionInputButton(_ sender: UIButton) {
         FunctionLabel.text = FunctionLabel.text! + sender.titleLabel!.text!
    }
    
    @IBOutlet weak var CurveLabel: UILabel!
    @IBAction func DisplayCurve(_ sender: UIButton) {
        guard self.FunctionLabel.text != nil else {
            return
        }
        functionDraw()
    }
    
    @IBAction func ClearFunction(_ sender: UIButton) {
        self.FunctionLabel.text = ""
    }
    
    func functionDraw() {
       let rect = CGRect(x: 0, y: 0, width: CurveLabel.frame.width, height: CurveLabel.frame.height)
       //创建FunctionDraw
       let view = FunctionDraw(frame: rect)
       //传入需要绘制的函数
       view.drawCurve { x in
           let oldExpression: String = self.FunctionLabel.text!   //"1-2+x*4+(10/5-6+7+(-8*9)-0)+1.1+0.2*0.3"
           var expression = oldExpression.replacingOccurrences(of: "x", with: "(\(x))") //x两边的括号以防负数造成负号和其他操作符直接相连
           expression = expression + "#"
           let exp = LinkStack<Double>()
           let cal = CGFloat(exp.EvaluateExpression(exp: expression)!)
           //print("计算结果: \(expression0) = \(cal)")

           return cal
       }
       //将当前视图加入到视图控制器中
       CurveLabel.addSubview(view)
    }
    
    @IBOutlet var ButtonCornerRadius: [UIButton]!
    func updateView() {
        if ButtonCornerRadius != nil {
            for button in ButtonCornerRadius {
                button.layer.cornerRadius = button.frame.height / 2
//                button.titleLabel?.font = UIFont.systemFont(ofSize: 80)
                //button.titleLabel?.adjustsFontSizeToFitWidth = true
                //button.titleLabel?.adjustsFontForContentSizeCategory = true
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
