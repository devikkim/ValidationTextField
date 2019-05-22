//
//  ViewController.swift
//  ValidationTextField
//
//  Created by devikkim@gmail.com on 04/16/2019.
//  Copyright (c) 2019 devikkim@gmail.com. All rights reserved.
//

import UIKit
import ValidationTextField

class ViewController: UIViewController {
  
  @IBOutlet weak var nameTextField: ValidationTextField!
  @IBOutlet weak var passwordTextField: ValidationTextField!
  @IBOutlet weak var passwordConfirmTextField: ValidationTextField!
  @IBOutlet weak var emailTextField: ValidationTextField!
  @IBOutlet weak var comfirmButton: UIButton!
  
  
  @IBAction func touchConfirm(_ sender: UIButton) {
    print("nameTextField: \(nameTextField.isValid)")
    print("emailTextField: \(emailTextField.isValid)")
    print("passwordTextField: \(passwordTextField.isValid)")
    print("passwordConfirmTextField: \(passwordConfirmTextField.isValid)")
  }
  
  var validDic = ["name": false, "email":false, "pw":false, "pwc": false]
  
  var isValid: Bool? {
    didSet {
      comfirmButton.isEnabled = isValid ?? false
      comfirmButton.backgroundColor = isValid ?? false ? UIColor(red:0.07, green:0.56, blue:0.33, alpha:1.0) : .lightGray
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    nameTextField.validCondition = {$0.count > 5}
    emailTextField.validCondition = {$0.count > 5 && $0.contains("@")}
    passwordTextField.validCondition = {$0.count > 8}
    passwordConfirmTextField.validCondition = {
      guard let password = self.passwordTextField.text else {
        return false
      }
      return $0 == password
    }
    
    nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    passwordConfirmTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    
    nameTextField.successImage = UIImage(named: "success")
    nameTextField.errorImage = UIImage(named: "error")
    
    passwordTextField.successImage = UIImage(named: "thumb_up")
    passwordTextField.errorImage = UIImage(named: "thumb_down")
    
    passwordConfirmTextField.successImage = UIImage(named: "thumb_up")
    passwordConfirmTextField.errorImage = UIImage(named: "thumb_down")
    
    emailTextField.successImage = UIImage(named: "success")
    emailTextField.errorImage = UIImage(named: "error")
  }
  
  @objc func textFieldDidChange(_ textfield: UITextField) {
    let tf = textfield as! ValidationTextField
    
    switch tf {
    case nameTextField:
      validDic["name"] = tf.isValid
    case emailTextField:
      validDic["email"] = tf.isValid
    case passwordTextField:
      validDic["pw"] = tf.isValid
    case passwordConfirmTextField:
      validDic["pwc"] = tf.isValid
    default:
      break
    }
    
    isValid = validDic.reduce(true){ $0 && $1.value}
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}

