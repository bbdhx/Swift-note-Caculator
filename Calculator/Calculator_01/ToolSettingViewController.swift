//
//  ToolSettingViewController.swift
//  Calculator_01
//
//  Created by mac1014 on 2021/2/25.
//  Copyright © 2021 Kong. All rights reserved.
//

import UIKit

class ToolSettingViewController: UIViewController {

    var toolSetting: ToolSetting? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        redSlider.value = Float((toolSetting?.backgroundColor.cgColor.components?[0])!)
        greenSlider.value = Float((toolSetting?.backgroundColor.cgColor.components?[1])!)
        blueSlider.value = Float((toolSetting?.backgroundColor.cgColor.components?[2])!)
        
        updateColor()
        backgroundColorView.layer.cornerRadius = 10
        backgroundColorView.layer.borderWidth = 5
    }
    
    @IBOutlet weak var backgroundColorView: UIView!
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    @IBAction func sliderChange(_ sender: UISlider) {
        updateColor()
    }
    
    
     @discardableResult func updateColor() -> UIColor{
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        
        red = CGFloat(redSlider.value)
        green = CGFloat(greenSlider.value)
        blue = CGFloat(blueSlider.value)
    
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1)
        backgroundColorView.backgroundColor = color
        toolSetting?.backgroundColor = color
        return color
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
