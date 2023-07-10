//
//  Calculator.swift
//  Calculator_01
//
//  Created by mac1014 on 2020/11/24.
//  Copyright © 2020 Kong. All rights reserved.
//

import Foundation

struct Calculator {
    var firstOperand: NSDecimalNumber
    var secondOperand: NSDecimalNumber
    var decimalPointFlag: Bool
    var isSecond: Bool
    var operatorFlag: String
    var hasOperator: Bool
    var afterResultFlag: Bool
    
    init() {
        firstOperand = 0.0
        secondOperand = 0.0
        decimalPointFlag = false
        isSecond = false
        operatorFlag = ""
        hasOperator = false
        afterResultFlag = false
    }
}
