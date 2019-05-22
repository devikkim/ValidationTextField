# ValidationTextField

[![CI Status](https://img.shields.io/travis/devikkim@gmail.com/ValidationTextField.svg?style=flat)](https://travis-ci.org/devikkim@gmail.com/ValidationTextField)
[![Version](https://img.shields.io/cocoapods/v/ValidationTextField.svg?style=flat)](https://cocoapods.org/pods/ValidationTextField)
[![Platform](https://img.shields.io/cocoapods/p/ValidationTextField.svg?style=flat)](https://cocoapods.org/pods/ValidationTextField)

A UITextField that easy validate text of UITextField
## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

* demo.gif

<img alt="Demo" src="/References/demo.gif?raw=true" width="290">&nbsp;


* can change success image, error image

<img alt="Demo" src="/References/demo.png?raw=true" width="290">&nbsp;

* sample code

```swift
@IBOutlet weak var nameTextField: ValidationTextField!
@IBOutlet weak var passwordTextField: ValidationTextField!
@IBOutlet weak var passwordConfirmTextField: ValidationTextField!
@IBOutlet weak var emailTextField: ValidationTextField!

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

}
```

## Installation

ValidationTextField is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ValidationTextField'
```

## Author

devikkim@gmail.com

## License

Apache License Version 2.0
