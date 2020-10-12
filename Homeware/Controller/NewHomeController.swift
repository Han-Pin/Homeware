//
//  NewHomeController.swift
//  Homeware
//
//  Created by Han-Pin on 2020/9/1.
//  Copyright © 2020 Han-Pin. All rights reserved.
//

import UIKit
import CoreData

class NewHomeController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var newImageView: UIImageView!
    
    @IBOutlet var newNameTextField: UITextField! {
        didSet {
            newNameTextField.tag = 1
            newNameTextField.becomeFirstResponder()
            newNameTextField.delegate = self
        }
    }
    
    @IBOutlet var newQuantityTextField: UITextField! {
        didSet {
            newQuantityTextField.tag = 2
            newQuantityTextField.keyboardType = .numberPad
            newQuantityTextField.delegate = self
            
        }
    }
    
    @IBOutlet var newUseTextField: UITextField! {
        didSet {
            newUseTextField.tag = 3
            newUseTextField.layer.cornerRadius = 5.0
            newUseTextField.layer.masksToBounds = true
        }
    }
//    關掉鍵盤
    @IBOutlet var newToolbar: UIToolbar!
    
    @IBAction func doneButtonClick(_ sender: Any) {
        
        newNameTextField.resignFirstResponder()
        newQuantityTextField.resignFirstResponder()
        newUseTextField.resignFirstResponder()
    }
    
    @IBAction func newSaveButton(_ sender: Any) {
        
        
        
        if newNameTextField.text == nil || Int(newQuantityTextField.text!)! > 999 || newQuantityTextField == nil {
//            資料未填
            if newNameTextField.text == nil {
                let alertController = UIAlertController(title: "問題", message: "名稱未輸入", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(alertAction)
                present(alertController, animated: true, completion: nil)
            } else if Int(newQuantityTextField.text!)! > 999 {
                let alertController = UIAlertController(title: "問題", message: "數值超出999", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(alertAction)
                present(alertController, animated: true, completion: nil)
            } else if newQuantityTextField == nil {
                let alertController = UIAlertController(title: "問題", message: "數值未輸入", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(alertAction)
                present(alertController, animated: true, completion: nil)
            }
            
        } else {
//            資料新增
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                stock = StockMO(context: appDelegate.persistentContainer.viewContext)
                stock.name = newNameTextField.text
                if let stockQuantity: Int16 = Int16(newQuantityTextField.text!) {
                    stock.quantity = stockQuantity
                }
                stock.use = newUseTextField.text
                stock.star = false
                if let stockimage = newImageView.image {
                    stock.image = stockimage.pngData()
                }
                
                print("存擋成功")
                appDelegate.saveContext()
                dismiss(animated: true, completion: nil)
            }
        }
        
        
        
        
    }
    
    var stock: StockMO!
    
    
//    下一個
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = view.viewWithTag(textField.tag + 1) {
            textField.resignFirstResponder()
            nextTextField.becomeFirstResponder()
        }
        return true
    }
//    選取照片或相機
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let newphoto = UIAlertController(title: "", message: "Chose your photo source", preferredStyle: .actionSheet)
            
            let newcameraAction = UIAlertAction(title: "相機", style: .default, handler: { (action) in
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .camera
                    imagePicker.delegate = self
                    self.present(imagePicker, animated: true, completion: nil)
                    
                }
            })
            
            let newphotoLibraryAction = UIAlertAction(title: "從相片中選取", style: .default, handler: { (action) in
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .photoLibrary
                    imagePicker.delegate = self
                    self.present(imagePicker, animated: true, completion: nil)
                    
                }
            })
            
            let alertAction = UIAlertAction(title: "取消", style: .default, handler: nil)
            
            
            newphoto.addAction(newcameraAction)
            newphoto.addAction(newphotoLibraryAction)
            newphoto.addAction(alertAction)
            
            present(newphoto, animated: true, completion: nil)
            
            
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImageView.image = selectedImage
            newImageView.contentMode = .scaleAspectFill
            newImageView.clipsToBounds = true
        }
//        約束條件
        let leadingConstraint = NSLayoutConstraint(item: newImageView as Any, attribute: .leading, relatedBy: .equal, toItem: newImageView.superview, attribute: .leading, multiplier: 1, constant: 0)
        leadingConstraint.isActive = true
        
        let trailingConstraint = NSLayoutConstraint(item: newImageView as Any, attribute: .trailing, relatedBy: .equal, toItem: newImageView.superview, attribute: .trailing, multiplier: 1, constant: 0)
        trailingConstraint.isActive = true
        
        let topConstraint = NSLayoutConstraint(item: newImageView as Any, attribute: .top, relatedBy: .equal, toItem: newImageView.superview, attribute: .top, multiplier: 1, constant: 0)
        topConstraint.isActive = true
        
        let bottomConstraint = NSLayoutConstraint(item: newImageView as Any, attribute: .bottom, relatedBy: .equal, toItem: newImageView.superview, attribute: .bottom, multiplier: 1, constant: 0)
        bottomConstraint.isActive = true
        
        
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
//        取消分隔線
        tableView.separatorStyle = .none
//        裝上鍵盤完成
        newNameTextField.inputAccessoryView = newToolbar
        newQuantityTextField.inputAccessoryView = newToolbar
        newUseTextField.inputAccessoryView = newToolbar
    }

    // MARK: - Table view data source

    

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
