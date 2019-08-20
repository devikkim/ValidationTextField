//
//  DevikTextField.swift
//  GMETextFIeld
//
//  Created by InKwon Devik Kim on 16/04/2019.
//  Copyright © 2019 devikkim. All rights reserved.
//

import UIKit

@available(iOS 9.0, *)
private enum ValidateType: String {
  case success
  case error
  case ready
  
  var image: UIImage? {
    let bundle = Bundle(for: ValidationTextField.self)
    let image = UIImage(named: self.rawValue, in: bundle,compatibleWith: nil)
    return image
  }
}

@available(iOS 9.0, *)
@IBDesignable
open class ValidationTextField: UITextField {
  
  // MARK: Heights
  
  private var lineHeight: CGFloat = 0
  private var selectedLineHeight: CGFloat = 0
  
  // MARK: IBInspectable
  @IBInspectable
  open var isShowTitle: Bool = true {
    didSet{
      update()
    }
  }
  @IBInspectable
  open var isUseTitle: Bool = true {
    didSet {
      update()
    }
  }
  
  @IBInspectable
  open var titleText: String = "TITLE" {
    didSet {
      update()
      
      statusImageView.heightAnchor.constraint(equalToConstant: max(titleFont.lineHeight, titleLabel.intrinsicContentSize.height)).isActive = true
      statusImageView.widthAnchor.constraint(equalToConstant: max(titleFont.lineHeight, titleLabel.intrinsicContentSize.height)).isActive = true
      
      statusImageView.layoutIfNeeded()
    }
  }
  
  @IBInspectable
  open var titleFont: UIFont = .systemFont(ofSize: 14) {
    didSet{
      update()
      createTitleLabel()
    }
  }
  @IBInspectable
  open var titleColor: UIColor = UIColor(red:0.49, green:0.49, blue:0.49, alpha:1.0) {
    didSet{
      update()
    }
  }
  
  @IBInspectable
  open var errorColor: UIColor = UIColor(red:0.99, green:0.16, blue:0.11, alpha:1.0) {
    didSet{
      update()
    }
  }
  
  @IBInspectable
  open var errorFont: UIFont = .systemFont(ofSize: 12) {
    didSet{
      update()
      createTitleLabel()
    }
  }
  
  @IBInspectable
  open var errorMessage: String? {
    didSet{
      update()
    }
  }
  
  @IBInspectable
  open var disabledColor: UIColor = UIColor(white: 0.88, alpha: 1.0) {
    didSet {
      update()
      updatePlaceholder()
    }
  }
  
  @IBInspectable
  open override var placeholder: String? {
    didSet {
      setNeedsDisplay()
      update()
    }
  }
  
  @IBInspectable
  open var placeholderColor: UIColor = UIColor(red:0.49, green:0.49, blue:0.49, alpha:1.0) {
    didSet {
      updatePlaceholder()
    }
  }
  
  @IBInspectable
  open var leftImage: UIImage? {
    didSet {
      leftViewMode = .always
      let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
      imageView.image = leftImage
      leftView = imageView
    }
  }
  
  
  // MARK: Properties
  
  open var validCondition: ((String) -> Bool)?
  
  open var isValid = false
  
  open var successImage: UIImage?
  
  open var errorImage: UIImage?
  
  open lazy var statusImageView = UIImageView()
  
  private lazy var titleLabel = UILabel()
  
  private lazy var errorLabel = UILabel()
  
  private lazy var lineView = UIView()
  
  private lazy var containerView = UIStackView()
  
  private var validateStatus: ValidateType = .ready {
    didSet {
      switch validateStatus {
      case .success:
        guard let successImage = successImage else {
          statusImageView.image = validateStatus.image
          return
        }
        statusImageView.image = successImage
        
      case .error:
        guard let errorImage = errorImage else {
          statusImageView.image = validateStatus.image
          return
        }
        statusImageView.image = errorImage
        
      case .ready:
        statusImageView.image = errorImage
      }
      
    }
  }
  
  private var titleFadeInDuration: TimeInterval = 0.3
  
  private var titleFadeOutDuration: TimeInterval = 0.5
  
  private var placeholderFont: UIFont? {
    didSet {
      updatePlaceholder()
    }
  }
  
  private var isTitleVisible: Bool {
    return hasText
  }
  
  private var editingOrSelected: Bool {
    return super.isEditing || isSelected
  }
  
  // MARK: Initialize
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    initValidationTextField()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initValidationTextField()
  }
  
  private func initValidationTextField() {
    borderStyle = .none
    createTitleLabel()
    createLineView()
    createErrorLabel()
    
    addTarget(self, action: #selector(editingChanged), for: [.editingChanged])
  }
  
  @objc
  private func editingChanged() {
    if let isValid = validCondition?(self.text ?? ""), !isValid {
      self.isValid = isValid
      validateStatus = .error
    } else {
      isValid = true
      validateStatus = .success
    }
    
    update()
    
    updateTitleVisibility(true)
  }
  
  private func createTitleLabel() {
    titleLabel = UILabel()
    
    titleLabel.autoresizingMask = [.flexibleWidth,. flexibleHeight]
    titleLabel.font = titleFont
    titleLabel.textColor = titleColor
    
    statusImageView.translatesAutoresizingMaskIntoConstraints = false
    statusImageView.contentMode = .scaleAspectFill
    
    containerView = UIStackView()
    containerView.axis = .horizontal
    containerView.spacing = 5
    
    containerView.addArrangedSubview(titleLabel)
    containerView.addArrangedSubview(statusImageView)
    containerView.addArrangedSubview(UILabel())
    
    containerView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
    containerView.translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(containerView)
  }
  
  private func createLineView() {
    lineView.isUserInteractionEnabled = false
    lineView.backgroundColor = titleColor
    configureDefaultLineHeight()
    
    lineView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
    addSubview(lineView)
  }
  
  private func createErrorLabel() {
    errorLabel.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
    addSubview(errorLabel)
  }
  
  private func titleHeight() -> CGFloat {
    return titleLabel.font.lineHeight
  }
  
  private func errorHeight() -> CGFloat {
    return errorLabel.font.lineHeight
  }
  
  private func configureDefaultLineHeight() {
    let pixel: CGFloat = 1.0 / UIScreen.main.scale
    lineHeight = 2.0 * pixel
    selectedLineHeight = 2.0 * lineHeight
  }
  
  private func titleRectForBounds(_ bounds: CGRect, editing: Bool) -> CGRect {
    if isShowTitle {
      return CGRect(
        x: 0,
        y: 0,
        width: bounds.size.width,
        height: titleHeight()
      )
    } else {
      if editing {
        return CGRect(
          x: 0,
          y: 0,
          width: bounds.size.width,
          height: titleHeight()
        )
      } else {
        return CGRect(
          x: 0,
          y: titleHeight(),
          width: bounds.size.width,
          height: titleHeight()
        )
      }
    }
  }
  
  private func lineViewRectForBounds(_ bounds: CGRect, editing: Bool) -> CGRect {
    let height = editing ? selectedLineHeight : lineHeight
    
    return CGRect(
      x: 0,
      y: bounds.size.height - height,
      width: bounds.size.width,
      height: height
    )
  }
  
  private func errorLabelRectForBounds(_ bounds: CGRect) -> CGRect {
    if isValid {
      return CGRect(
        x: 0,
        y: bounds.height + errorHeight(),
        width: 0,
        height: 0
      )
    } else {
      return CGRect(
        x: 0,
        y: bounds.height,
        width: bounds.size.width,
        height: errorHeight()
      )
    }
  }
  
  private func textHeight() -> CGFloat {
    guard let font = self.font else { return 0.0 }
    
    return font.lineHeight + 3.0
  }
  
  private func updateTitleVisibility(_ animated: Bool = false) {
    let alpha: CGFloat
    
    if isShowTitle {
      alpha = 1.0
    } else {
      alpha = isTitleVisible ? 1.0 : 0.0
    }
    
    let frame = titleRectForBounds(bounds, editing: isTitleVisible)
    
    let errorAlpha: CGFloat = isValid || text == "" ? 0.0 : 1.0
    let errorLabelFrame = errorLabelRectForBounds(bounds)
    
    let updateBlock = {() -> Void in
      if !self.isShowTitle {
        self.containerView.alpha = alpha
        self.containerView.frame = frame
      }
      
      self.errorLabel.alpha = errorAlpha
      self.errorLabel.frame = errorLabelFrame
    }
    
    if animated {
      #if swift(>=4.2)
      let animationOptions: UIView.AnimationOptions = .curveEaseOut
      #else
      let animationOptions: UIViewAnimationOptions = .curveEaseOut
      #endif
      
      let duration = isTitleVisible ? titleFadeInDuration : titleFadeOutDuration
      
      UIView.animate(
        withDuration: duration,
        delay: 0,
        options: animationOptions,
        animations: { () -> Void in
          updateBlock()
      },
        completion: nil)
    }
  }
  
  private func update(){
    if !isValid && text != "" {
      errorLabel.text = errorMessage
      errorLabel.textColor = errorColor
      errorLabel.font = errorFont
      lineView.backgroundColor = errorColor
    } else {
      lineView.backgroundColor = titleColor
    }
    
    if isUseTitle {
      containerView.isHidden = false
      containerView.alpha = 1.0
    } else {
      containerView.isHidden = true
      containerView.alpha = 0.0
    }
    
    titleLabel.text = titleText
    titleLabel.textColor = titleColor
    titleLabel.font = titleFont
    
    updateTitleVisibility(true)
    
    if !isEnabled {
      lineView.backgroundColor = disabledColor
    }
  }
  
  private func updatePlaceholder() {
    guard let placeholder = placeholder, let font = placeholderFont ?? font else {
      return
    }
    let color = isEnabled ? placeholderColor : disabledColor
    #if swift(>=4.2)
    attributedPlaceholder = NSAttributedString(
      string: placeholder,
      attributes: [
        NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: font
      ]
    )
    #elseif swift(>=4.0)
    attributedPlaceholder = NSAttributedString(
      string: placeholder,
      attributes: [
        NSAttributedStringKey.foregroundColor: color, NSAttributedStringKey.font: font
      ]
    )
    #else
    attributedPlaceholder = NSAttributedString(
      string: placeholder,
      attributes: [NSForegroundColorAttributeName: color, NSFontAttributeName: font]
    )
    #endif
  }
  
  override open func textRect(forBounds bounds: CGRect) -> CGRect {
    let superRect = super.textRect(forBounds: bounds)
    let titleHeight = self.titleHeight()
    
    return CGRect(
      x: superRect.origin.x,
      y: titleHeight,
      width: superRect.size.width,
      height: superRect.size.height - titleHeight - selectedLineHeight
    )
  }
  
  override open func editingRect(forBounds bounds: CGRect) -> CGRect {
    let superRect = super.editingRect(forBounds: bounds)
    let titleHeight = self.titleHeight()
    
    let padding: CGFloat = leftImage == nil ? 0 : 5
    
    return CGRect(
      x: superRect.origin.x + padding,
      y: titleHeight,
      width: superRect.size.width,
      height: superRect.size.height - titleHeight - selectedLineHeight
    )
  }
  
  override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    let superRect = super.editingRect(forBounds: bounds)
    let titleHeight = self.titleHeight()
    
    let padding: CGFloat = leftImage == nil ? 0 : 5
    
    let rect = CGRect(
      x: superRect.origin.x + padding,
      y: titleHeight,
      width: bounds.size.width,
      height: bounds.size.height - titleHeight - selectedLineHeight
    )
    return rect
  }
  
  override open func leftViewRect(forBounds bounds: CGRect) -> CGRect {
    let rect = CGRect (
      x: 0,
      y: (titleHeight() + (bounds.size.height - titleHeight() - selectedLineHeight) / 2) - 10 ,
      width: 20,
      height: 20
    )
    return rect
  }
  
  override open func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    
    borderStyle = .none
    
    isSelected = true
    invalidateIntrinsicContentSize()
  }
  
  override open func layoutSubviews() {
    super.layoutSubviews()
    
    self.containerView.frame = titleRectForBounds(
      bounds,
      editing: isTitleVisible
    )
    
    self.lineView.frame = lineViewRectForBounds(
      bounds,
      editing: editingOrSelected
    )
    
    self.errorLabel.frame = errorLabelRectForBounds(bounds)
  }
  
  override open var intrinsicContentSize: CGSize {
    return CGSize(width: bounds.size.width, height: titleHeight() + textHeight() + 10)
  }
}
