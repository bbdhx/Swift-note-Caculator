import UIKit


class LinkStack<T>
{
    var stack = [T]()
    
    init() {
    }
    
    var operandStack = [Double]()
    var operatorStack = [String]()
    
    func EvaluateExpression(exp: String) -> T? {
        var parenthesesL: Int = 0 //判断左括号匹配
        var parenthesesR: Int = 0 //判断右括号匹配
        var decimalpoint: Int = 0 //判断小数点匹配
        
        for c in exp {
            if (c == " " || c == "#") { continue }
            else if (c >= "0" && c <= "9") { continue }
            else if (c == ".") { decimalpoint += 1 }
            else if ((c == "+" || c == "-" || c == "*" || c == "/") && decimalpoint <= 1) {
                decimalpoint = 0
            }
            else if (c == "(") {
                parenthesesL += 1
            }
            else if (c == ")") {
                parenthesesR += 1
            }
            else {
                print("error：出现非法字符。")
                return nil
            }
            if (decimalpoint > 1) {
                print("error：小数点有误。")
                return nil
            }
        }
        
        if (parenthesesL != parenthesesR) {
            print("error：括号不匹配。")
            return nil
        }
        
        print("逆波兰式为：")
        var Former = exp.first!
        var Present: Double = 0      //操作数
        var PosOrNeg: Bool = false   //positive(true) and negative(false),标志表达式第一有效位的正负
        var Nofloat: Bool = true         //int(true) float(false) 标志操作数是否为浮点数
        var Decimal: Double = 10        //decimal,小数位的计算
        var IsZero: Bool = true          //0() !0() 判断操作数是否为0
        
        
        for x in exp {
            if (x == " ") {
                continue
            }
            else if (x.isNumber && Nofloat) {
                Present = 10 * Present + Double(x.wholeNumberValue!);
                PosOrNeg = true
                Former = x
                IsZero = false
                continue
            }
            else if (x == ".") {
                Nofloat = false
            }
            else if (x.isNumber && !Nofloat) {
                Present = Present + Double(x.wholeNumberValue!) / (Decimal * 1.0);
                Decimal *= 10
                PosOrNeg = true
                Former = x
                continue
            }
            else {
                if (Present != 0.0 || !IsZero) {
                    print("\(Present)  ")
                    operandStack.append(Present)
                    Present = 0
                    Decimal = 10
                    IsZero = true
                }
            }
            
            if (x == "+" || x == "-") {
                if ((PosOrNeg == false || Former == "(") && x == "-") {
                    operandStack.append(0);
                    operatorStack.append(String(x))
                    PosOrNeg = true
                    Former = x
                    Nofloat = true
                    continue
                }
                while (true) {
                    if (operatorStack.last != nil &&
                        (operatorStack.last! == "+" ||
                        operatorStack.last! == "-" ||
                        operatorStack.last! == "*" ||
                        operatorStack.last! == "/")) {
                        self.ProcessAnOperator();
                    }
                    else { break }
                }
                operatorStack.append(String(x));
                PosOrNeg = true
                Former = x
                Nofloat = true
                continue
            }
            else if (x == "*" || x == "/") {
                while (true) {
                    if (operatorStack.last != nil &&
                        (operatorStack.last! == "*" || operatorStack.last! == "/"))
                    {
                        self.ProcessAnOperator();
                    }
                    else { break }
                }
                operatorStack.append(String(x));
                PosOrNeg = true
                Former = x
                Nofloat = true
                continue
            }
            else if (x == "(") {
                operatorStack.append(String(x));
                PosOrNeg = true
                Former = x
                Nofloat = true
                continue
            }
            else if (x == ")") {
                while (operatorStack.last != nil && operatorStack.last! != "(") {
                    self.ProcessAnOperator();
                }
                operatorStack.popLast();
                PosOrNeg = true
                Former = x
                Nofloat = true
            }
        }
        
        while (!operatorStack.isEmpty) {
            self.ProcessAnOperator();
        }
        
        return operandStack.popLast() as? T;
    }
    
    func ProcessAnOperator() {
        let opOne = self.operandStack.popLast()!
        let opTwo = self.operandStack.popLast()!
        
        let opr = self.operatorStack.popLast()!
        print(opr)
        switch opr {
        case "+":
            self.operandStack.append(opTwo + opOne)
        case "-":
            self.operandStack.append(opTwo - opOne)
        case "*":
            self.operandStack.append(opTwo * opOne)
        case "/":
            self.operandStack.append(opTwo / opOne)
        default:
            return
        }
    }
}
