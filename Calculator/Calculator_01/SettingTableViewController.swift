//
//  SettingTableViewController.swift
//  Calculator_01
//
//  Created by mac1014 on 2020/12/25.
//  Copyright © 2020 Kong. All rights reserved.
//

import UIKit
import MessageUI
import SafariServices

class SettingTableViewController: UITableViewController, UITextFieldDelegate, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // TODO: - Share
    

    // MARK: - Email
    @IBAction func emailButtonTapped(_ sender: UIButton) {
        guard MFMailComposeViewController.canSendMail() else {
            print("Can not send mail.")
            return
        }
        
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        
        mailComposer.setToRecipients(["931916310@qq.com"])
        mailComposer.setSubject("Title")
        mailComposer.setMessageBody("Hello World!", isHTML: false)
        
        present(mailComposer, animated: true, completion: nil)
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Safari
    @IBOutlet weak var safariTextField: UITextField!
    
    // MARK: dismissing by pressing the Return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: dismissing by tapping elsewhere
    @IBAction func backgroundTap(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    
    var url: String = ""
    @IBAction func textEditingChanged(_ sender: UITextField) {
        url = safariTextField.text ?? ""
    }
    @IBAction func safariButtonTapped(_ sender: UIButton) {
        print("safari")
        
        let urlString = "https://cn.bing.com/search?q=\(url)"
        
        let charSet = CharacterSet.urlQueryAllowed as! NSMutableCharacterSet

        let encodingString = urlString.addingPercentEncoding(withAllowedCharacters: charSet as CharacterSet)
        
    //TODO: - Safari
        if let url = URL(string: encodingString as! String) {
             UIApplication.shared.open(url, options: [:], completionHandler: nil)
    //        let safariViewController = SFSafariViewController(url: url)
            
            //present(safariViewController, animated: true, completion: nil)
            print(urlString)
        }
        else {
            print("error")
        }
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - Table view data source
    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    */
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
