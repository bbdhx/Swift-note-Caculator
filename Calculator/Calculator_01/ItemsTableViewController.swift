//
//  ItemsTableViewController.swift
//  Calculator_01
//
//  Created by mac1014 on 2021/2/16.
//  Copyright © 2021 Kong. All rights reserved.
//

import UIKit
import LocalAuthentication

class ItemsTableViewController: UITableViewController {

    var itemStore: ItemStore!
    var toolSetting: ToolSetting? = nil
    var imageStore: ImageStore!
    var textViewStore: TextViewStore!
    var splitViewWithGesture: UISplitViewController? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        splitViewWithGesture?.presentsWithGesture = true
        
        tableView.reloadData()
        print("item view will appear")
        // MARK: - save all item
        let success = itemStore.saveChanges() &&
                toolSetting!.saveChanges() &&
                imageStore.saveChanges() &&
                textViewStore.saveChanges()
        if (success) {
            print("Saved all of the Items")
        } else {
            print("Could not save any of the Items")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        splitViewWithGesture?.presentsWithGesture = false
    }
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
        
        //指纹识别
//        let fingerPrint = UserDefaults.standard.value(forKey: "fingerPrint")
//        if (true)
//        {
//            //指纹解锁
//            let authenticationContext = LAContext()
//            var error: NSError?
//
//            //步骤1：检查Touch ID是否可用
//            let isTouchIdAvailable = authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,error: &error)
//            //真机上可以使用,模拟器上不可使用
//            if isTouchIdAvailable
//            {
//                print("恭喜，Touch ID可以使用！")
//                //步骤2：获取指纹验证结果
//                authenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "需要验证您的指纹来确认您的身份信息", reply:
//                    {
//                        (success, error) -> Void in
//                        if success
//                        {
//                            NSLog("恭喜，您通过了Touch ID指纹验证！")
////                            "恭喜，您通过了Touch ID指纹验证！".ext_debugPrintAndHint()
//                            //回主线程去隐藏View,若是在子线程中隐藏则延迟太厉害
//                            OperationQueue.main.addOperation
//                            {
//                                    print("当前线程是\(Thread.current)")
//                                    self.gestureView.isHidden = true
//                            }
//                            return
//
//                        }
//                        else
//                        {
//                            print("抱歉，您未能通过Touch ID指纹验证！\n\(String(describing: error))")
//                        }
//                })
//
//            }
//            else
//            {
//                print("指纹不能用")
//            }
//
//
//        }
//        else
//        {
//            print("证明没添加过")
//        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        navigationItem.leftBarButtonItem = editButtonItem
    }

    // MARK: - addNewItem Button
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        // Creat a new item and add it to the store
        let newItem = itemStore.creat()
        
        // Figure out where that item is in the array
        if let index = itemStore.allItems.firstIndex(of: newItem)
        {
            let indexPath = IndexPath(row: index, section: 0)
            
            // Insert this new row into the table
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        // return 0
        return itemStore.allItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)

        //creat an instance of UITableViewCell, with the default appearence
        
        //Set the text on the cell with the description of the item
        //that is at the nth index of the items, where n = row this cell
        //will appear in on the tableview
        let item = itemStore.allItems[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = "- \(item.dateCreat)"

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // MARK: - editing for delete
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let item = itemStore.allItems[indexPath.row]
            itemStore.removeItem(item)
            // Delete the image and text view from the ImageStore
            imageStore.allImageStore[item.itemKey] = nil
            textViewStore.allTextViewStore[item.itemKey] = nil
            // Also remove that row from the table view with an animation
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    // MARK: - moveItem
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // Update the model
        itemStore.moveItem(from: fromIndexPath.row, to: destinationIndexPath.row)
    }
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        // If the triggered segue is the "showItem" segue
        switch segue.identifier {
        case "showItem"?:
            // Figure out which row was just tapped
            if let row = tableView.indexPathForSelectedRow?.row
            {
                // Get the item associated with this row and pass it along
                let item = itemStore.allItems[row]
                
                let detailViewController = (segue.destination as! DetailViewController)
                detailViewController.splitViewWithGesture = splitViewWithGesture
                detailViewController.item = item
                
                let detailDrawViewController = segue.destination.view.viewWithTag(1) as! DrawView
                
                // Line
                detailDrawViewController.lineStoreKit = item.lineStore
                detailDrawViewController.allLineWithStyle = item.allLineWithSort
                
                // Image, text view and item key
                if imageStore.allImageStore[item.itemKey] == nil {
                    imageStore.allImageStore[item.itemKey] = Image()
                }
                if textViewStore.allTextViewStore[item.itemKey] == nil {
                    textViewStore.allTextViewStore[item.itemKey] = TextView()
                }
                detailDrawViewController.image = imageStore.allImageStore[item.itemKey]
                detailDrawViewController.textView = textViewStore.allTextViewStore[item.itemKey]
                detailDrawViewController.itemKey = item.itemKey
                
                // background color
                detailDrawViewController.backgroundColor = item.drawViewBackgroundColor
            }
        case "showSetting"?:
//            let backgroundColor = itemStore.backgroundColor
            let tabBarController = segue.destination as! UITabBarController
            let toolSettingViewController = tabBarController.viewControllers?[0] as! ToolSettingViewController
            toolSettingViewController.toolSetting = toolSetting
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
}
