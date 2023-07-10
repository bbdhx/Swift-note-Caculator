//
//  SplitViewController.swift
//  Calculator_01
//
//  Created by mac1014 on 2021/3/5.
//  Copyright © 2021 Kong. All rights reserved.
//

import UIKit
import LocalAuthentication

class SplitViewController: UISplitViewController {
    
    var gestureView = UIView()
    var buttonForGesture = UIButton()
    let ScreenWidth = UIScreen.main.bounds.size.width
    let ScreenHeight = UIScreen.main.bounds.size.height
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.presentsWithGesture = false
        
        

        
        touchID()
    }
    
    

    @objc func touchID() {
        //手势密码
        
        gestureView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        gestureView.backgroundColor = .darkGray
        view.addSubview(gestureView)
        gestureView.addSubview(buttonForGesture)
        
        buttonForGesture.backgroundColor = .gray
        buttonForGesture.layer.cornerRadius = 8
        buttonForGesture.layer.opacity = 0.8
        buttonForGesture.translatesAutoresizingMaskIntoConstraints = false
        let w = NSLayoutConstraint(item: buttonForGesture, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: 80)
        let h = NSLayoutConstraint(item: buttonForGesture, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: 40)
        let x = NSLayoutConstraint(item: buttonForGesture, attribute: .centerX, relatedBy: .equal, toItem: gestureView, attribute: .centerX, multiplier: 1, constant: 0)
        let y = NSLayoutConstraint(item: buttonForGesture, attribute: .centerY, relatedBy: .equal, toItem: gestureView, attribute: .centerY, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([w, h, x, y])
        buttonForGesture.setTitle("Touch ID", for: .normal)
        buttonForGesture.addTarget(self, action: #selector(touchID), for: .touchUpInside)

        
        let context = LAContext()
        var error: NSError?
        context.localizedCancelTitle = "取消"
        // iOS 9 之后锁定指纹识别之后,如果需要立即弹出输入密码界面需要使用deviceOwnerAuthentication这个属性重新发起验证
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
             print("TouchID可用")
             context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "指纹验证解锁") { [weak self](success, error) in
                 if success {
                     print("验证成功")
                    //回主线程去隐藏View,若是在子线程中隐藏则延迟太厉害
                    OperationQueue.main.addOperation
                    {
                        print("当前线程是\(Thread.current)")
                        self!.gestureView.isHidden = true
                    }
                 } else {
                     if let error = error as NSError? {
                         switch error.code { //LAError的几种错误信息
                         case LAError.authenticationFailed.rawValue:
                             print("验证信息出错")
                         case LAError.userFallback.rawValue:
                             print("用户选择了另一种方式")
                         case LAError.userCancel.rawValue:
                             print("用户取消")
                         case LAError.systemCancel.rawValue:
                             print("切换到前台被取消")
                         case LAError.passcodeNotSet.rawValue:
                             print("没有设置TouchID")
                         case LAError.appCancel.rawValue:
                             print("在验证中被其他app中断")
                         case LAError.invalidContext.rawValue:
                             print("验证出错")
                         default:
                             print("验证失败")
                         }
                     }
                 }
             }
        } else {
             print("TouchID不可用")
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
