//
//  ViewController.swift
//  Calculator_01
//
//  Created by mac1014 on 2020/11/24.
//  Copyright © 2020 Kong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        updateView()
    }
    
    var calculator = Calculator()
    
    //MARK: - 结果框
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var oldResultLabel: UILabel!
    
    
    //MARK: - 0-9,操作数
    @IBAction func operandButtonTapped(_ sender: UIButton) {
        //
        guard resultLabel.text!.count < 19 || calculator.hasOperator else { return }
        
        //按下=按键后直接按操作数按键，则重置计算
        if calculator.afterResultFlag {
            clearButtonTapped()
        }
        
        if resultLabel.text == "0" || calculator.hasOperator || resultLabel.text == "Error" {
            calculator.hasOperator = false
            resultLabel.text = ""
        }
        
        resultLabel.text = resultLabel.text! + sender.titleLabel!.text!
    }
    
    //MARK: - +-*/,四则运算符
    @IBAction func operatorButtonTapped(_ sender: UIButton) {
        calculator.afterResultFlag = false
        //******实现连续计算不用按=按键*****//
        //更新第二操作数
        if !calculator.hasOperator {
            calculator.secondOperand = stringToNSDecimalNumber(string: resultLabel.text!)
            //检查除数是否为0
            if !checkDivisor() {
                return
            }
            
            //计算结果
            let result = updateResult()
            
            //结果出现后，将第一操作数更新为结果
            calculator.firstOperand = result
            
            //将结果更新到界面
            resultLabel.text = result.description
        }
        //****************************//
        
        //更新操作符
        switch sender.titleLabel!.text {
        case "+":
            calculator.operatorFlag = "+"
        case "−":
            calculator.operatorFlag = "−"
        case "×":
            calculator.operatorFlag = "×"
            case "÷":
            calculator.operatorFlag = "÷"
        default:
            calculator.operatorFlag = ""
        }
        calculator.hasOperator = true
        
        //将显示的数作为第一操作数存储到firstOperand
        calculator.firstOperand = stringToNSDecimalNumber(string: resultLabel.text!)
        
        //同时将显示的数作为第二操作数存储到secondOperand
        calculator.secondOperand = stringToNSDecimalNumber(string: resultLabel.text!)
        
    }
    
    //MARK: - +/-,取反运算符
    @IBAction func reverseButtonTapped(_ sender: UIButton) {
        //将当前显示的数取相反值并更新操作数
        let result = stringToNSDecimalNumber(string: resultLabel.text!).multiplying(by: -1)
        resultLabel.text = result.description

        if calculator.hasOperator {
            calculator.firstOperand = result
        }
    }
    
    //MARK: - %,求百分比运算符
    @IBAction func percentButtonTapped(_ sender: UIButton) {
        let result = stringToNSDecimalNumber(string: resultLabel.text!).dividing(by: 100)
        resultLabel.text = result.description

        if calculator.hasOperator {
            calculator.firstOperand = result
        }
    }
    
    //MARK: - =,等于号
    @IBAction func resultButtonTapped() {
        
        if !calculator.hasOperator {
            //将显示的数作为第二操作数存储到secondOperand
            calculator.secondOperand = stringToNSDecimalNumber(string: resultLabel.text!)
            calculator.hasOperator = true
        }
        
        if !checkDivisor() {
            return
        }
        
        //进行第一操作数和第二操作数的运算
        let result = updateResult()
        
        //结果出现后，将第一操作数更新为结果
        calculator.firstOperand = result
        
        //将结果更新到界面
        resultLabel.text = result.description
        
        
        //标记按下=按键后是否直接继续输入数字，若是则标记为true，以便重置计算
        calculator.afterResultFlag = true
    }
    
    //MARK: - .-----小数点
    @IBAction func decimalButtonTapped(_ sender: UIButton) {
        calculator.afterResultFlag = false
        
        if calculator.hasOperator {
            resultLabel.text = "0."
            calculator.hasOperator = false
            return
        }
        if !resultLabel.text!.contains(".") {
            if resultLabel.text != "0" {
                resultLabel.text = resultLabel.text! + "."
            } else {
                resultLabel.text = "0."
            }
        }
    }
    
    //MARK: - AC,重制计算过程
    @IBAction func clearButtonTapped() {
        calculator.afterResultFlag = false
        resultLabel.text = "0"
        calculator.firstOperand = 0
        calculator.secondOperand = 0
        calculator.decimalPointFlag = false
        calculator.hasOperator = false
        calculator.isSecond = false
        calculator.operatorFlag = ""
    }
    
    //MARK: - 计算并返回结果
    var oldResult = [String]()
    func updateResult() -> NSDecimalNumber {
        var result:NSDecimalNumber = 0
        switch calculator.operatorFlag {
        case "+":
            result = calculator.firstOperand.adding(calculator.secondOperand)
        case "−":
            result = calculator.firstOperand.subtracting(calculator.secondOperand)
        case "×":
            result = calculator.firstOperand.multiplying(by: calculator.secondOperand)
        case "÷":
            //TODO: - 除法保留位数
            result = calculator.firstOperand.dividing(by: calculator.secondOperand)
        default:
            result = NSDecimalNumber(string: resultLabel.text!)
        }
        
        if calculator.operatorFlag != ""{
            if oldResult.count >= 6 {
                oldResult.remove(at: 0)
            }
            oldResult.append("\(calculator.firstOperand) \(calculator.operatorFlag) \(calculator.secondOperand) = \(result)\n")
            var old: String = ""
            for (_, oldResult) in oldResult.enumerated() {
                old = old + oldResult
            }
            oldResultLabel.text = old
            //oldResultLabel.text = "\(oldResultLabel.text ?? "")\n\(calculator.firstOperand) \(calculator.operatorFlag) \(calculator.secondOperand) = \(result)"
        }
        
        return result
    }
    
    //MARK: - 检查除数是否为0
    func checkDivisor() -> Bool{
        //若除数为0，则显示错误
        if calculator.operatorFlag == "÷" && calculator.secondOperand == 0.0 {
            //重置操作数和操作符
            calculator.firstOperand = 0
            calculator.secondOperand = 0
            calculator.operatorFlag = ""
            
            //显示Error提示
            resultLabel.text = "Error"
            
            return false
        }
        return true
    }

    //MARK: - 字符串转为NSDecimalNumber
    func stringToNSDecimalNumber(string: String) -> NSDecimalNumber {
        let numberOfDouble = NSDecimalNumber(string: string)
        return numberOfDouble
    }
    
    //MARK: - 设置按钮圆角
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
    
}
