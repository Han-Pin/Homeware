//
//  vcViewController.swift
//  Homeware
//
//  Created by Han-Pin on 2020/8/28.
//  Copyright © 2020 Han-Pin. All rights reserved.
//

import UIKit

class vcViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet var vcImageView: UIImageView!
    
    @IBOutlet var vcNameLabel: UILabel!
    
    @IBOutlet var vcquantityLabel: UILabel!
    
    @IBOutlet var modifyQuantityTextField: UITextField! {
        didSet {
            modifyQuantityTextField.tag = 2
            modifyQuantityTextField.delegate = self
        }
    }
    
    @IBOutlet var modifyUseTextField: UITextField! {
        didSet {
            modifyUseTextField.tag = 3
            modifyUseTextField.layer.cornerRadius = 5.0
            modifyUseTextField.layer.masksToBounds = true
        }
    }
    @IBOutlet var starImageView: UIImageView!
    
    @IBOutlet var useLabel: UILabel!
    
//    鍵盤修改
    
    @IBOutlet var vcToolbar: UIToolbar!
    
    @IBAction func vcButtonClick(_ sender: Any) {
        modifyTextField.resignFirstResponder()
        modifyQuantityTextField.resignFirstResponder()
        modifyUseTextField.resignFirstResponder()
    }
    
//  數量增加
    
    @IBOutlet var plueButtonClick: UIButton!
    @IBAction func plueButton(_ sender: Any) {
        if stock.quantity == 999 {
            let alertController = UIAlertController(title: "問題", message: "數值已達999無法再增加", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
        } else {
            if let appModify = (UIApplication.shared.delegate as? AppDelegate) {
                stock.quantity += 1
                vcquantityLabel.text = String(stock.quantity)
                appModify.saveContext()
            }
        }
        
        
        
        
    }
//    數量減少
    @IBOutlet var minusButtonClick: UIButton!
    
    @IBAction func minusButton(_ sender: Any) {
        if stock.quantity == 0 {
            let alertController = UIAlertController(title: "問題", message: "數值已達0無法再減少", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
        } else {
            if let appModify = (UIApplication.shared.delegate as? AppDelegate) {
                stock.quantity -= 1
                vcquantityLabel.text = String(stock.quantity)
                appModify.saveContext()
            }
        }
        
    }
//    修改圖片
    
    @IBAction func imageButton(_ sender: Any) {
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
    
//    修改
    
    @IBOutlet var modifyView: UIView!
//    讀取修改
    @IBAction func modifyNameButton(_ sender: Any) {
        for c in view.constraints {
            if c.identifier == "button" {
                c.constant = -220
                modifyTextField.text = stock.name
                modifyQuantityTextField.text = String(stock.quantity)
                modifyUseTextField.text = stock.use
                
                
                break
            }
        }
        plueButtonClick.isHidden = true
        minusButtonClick.isHidden = true
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    @IBOutlet var modifyTextField: UITextField! {
        didSet {
            modifyTextField.tag = 1
            modifyTextField.delegate = self
            
        }
    }
//    確認修改
    @IBAction func confirmButton(_ sender: Any) {
        for c in view.constraints {
            if c.identifier == "button" {
                c.constant = 300
                if let appModify = (UIApplication.shared.delegate as? AppDelegate) {
                    stock.name = modifyTextField.text
                    stock.use = modifyUseTextField.text
                    if Int(modifyQuantityTextField.text!)! > 999 {
                        modifyQuantityTextField.text = "999"
                        stock.quantity = Int16(modifyQuantityTextField.text!)!
                    } else if Int(modifyQuantityTextField.text!)! < 0 {
                        modifyQuantityTextField.text = "0"
                        stock.quantity = Int16(modifyQuantityTextField.text!)!
                    }
                    
                    
                    appModify.saveContext()
                    
                    vcNameLabel.text = stock.name
                    vcquantityLabel.text = String(stock.quantity)
                    useLabel.text = stock.use
                }
                break
            }
        }
        plueButtonClick.isHidden = false
        minusButtonClick.isHidden = false
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        
    }
//    取消修改
    @IBAction func cancelButton(_ sender: Any) {
        for c in view.constraints {
            if c.identifier == "button" {
                c.constant = 300
                break
            }
        }
        plueButtonClick.isHidden = false
        minusButtonClick.isHidden = false
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
//    下一個
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = view.viewWithTag(textField.tag + 1) {
            textField.resignFirstResponder()
            nextTextField.becomeFirstResponder()
        }
        return true
    }
//  修改
    override func viewWillAppear(_ animated: Bool) {
        view.addSubview(modifyView)
        modifyView.translatesAutoresizingMaskIntoConstraints = false
        
        modifyView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        modifyView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        modifyView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        let c = modifyView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 300)
        c.identifier = "button"
        c.isActive = true
        
        modifyView.layer.cornerRadius = 10
        super.viewWillAppear(animated)
    }
//   儲存修改圖片
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                
                
                vcImageView.image = selectedImage
                vcImageView.contentMode = .scaleAspectFill
                vcImageView.clipsToBounds = true
                
                if let appModifyimage = (UIApplication.shared.delegate as? AppDelegate) {
                    if let stockimage = vcImageView.image {
                        stock.image = stockimage.pngData()
                    }
                    appModifyimage.saveContext()
                }
                
                
            }
    //        約束條件
            let leadingConstraint = NSLayoutConstraint(item: vcImageView as Any, attribute: .leading, relatedBy: .equal, toItem: vcImageView.superview, attribute: .leading, multiplier: 1, constant: 0)
            leadingConstraint.isActive = true
            
            let trailingConstraint = NSLayoutConstraint(item: vcImageView as Any, attribute: .trailing, relatedBy: .equal, toItem: vcImageView.superview, attribute: .trailing, multiplier: 1, constant: 0)
            trailingConstraint.isActive = true
            
            let topConstraint = NSLayoutConstraint(item: vcImageView as Any, attribute: .top, relatedBy: .equal, toItem: vcImageView.superview, attribute: .top, multiplier: 1, constant: 0)
            topConstraint.isActive = true
            
            let bottomConstraint = NSLayoutConstraint(item: vcImageView as Any, attribute: .bottom, relatedBy: .equal, toItem: vcImageView.superview, attribute: .bottom, multiplier: 1, constant: 0)
            bottomConstraint.isActive = true
            
            
            dismiss(animated: true, completion: nil)
        }
    
    var stock: StockMO!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        vcNameLabel.text = stock.name
        vcquantityLabel.text = String(stock.quantity)
        if let stockimage = stock.image {
            vcImageView.image = UIImage(data: stockimage as Data)
            vcImageView.contentMode = .scaleAspectFill
            vcImageView.clipsToBounds = true
        }
        useLabel.text = stock.use
        starImageView.isHidden = stock.star ? false : true
//        裝上鍵盤完成
        modifyTextField.inputAccessoryView = vcToolbar
        modifyQuantityTextField.inputAccessoryView = vcToolbar
        modifyUseTextField.inputAccessoryView = vcToolbar

        // Do any additional setup after loading the view.
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
