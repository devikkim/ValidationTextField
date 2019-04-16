//
//  DevikTextField.swift
//  GMETextFIeld
//
//  Created by InKwon Devik Kim on 16/04/2019.
//  Copyright © 2019 devikkim. All rights reserved.
//

import UIKit

@IBDesignable
open class ValidationTextField: UITextField {
    
    // MARK: Heights
    
    private var lineHeight: CGFloat = 0
    private var selectedLineHeight: CGFloat = 0
    
    // MARK: IBInspectable
    
    @IBInspectable
    open var completedTitleText: String = "Completed!" {
        didSet {
            update()
        }
    }
    
    @IBInspectable
    open var completedTitleFont: UIFont = .systemFont(ofSize: 13) {
        didSet{
            update()
        }
    }
    
    @IBInspectable
    open var completedColor: UIColor = UIColor(red:0.07, green:0.56, blue:0.33, alpha:1.0) {
        didSet{
            update()
        }
    }
    
    @IBInspectable
    open var baseColor: UIColor = .darkGray {
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
    open var placeholderColor: UIColor = UIColor.lightGray {
        didSet {
            updatePlaceholder()
        }
    }
    
    
    // MARK: Properties
    
    open var validCondition: ((String) -> Bool)?
    
    open var isValid = false
    
    private var titleLabel: UILabel!
    
    private var lineView: UIView!
    
    private var _errorMessage: String?
    
    private var titleFadeInDuration: TimeInterval = 0.2
    
    private var titleFadeOutDuration: TimeInterval = 0.3
    
    private var placeholderFont: UIFont? {
        didSet {
            updatePlaceholder()
        }
    }
    
    private var hasErrorMessage: Bool{
        return self._errorMessage != nil && self._errorMessage != ""
    }
    
    private var isTitleVisible: Bool {
        return hasText || hasErrorMessage
    }
    
    private var editingOrSelected: Bool {
        return super.isEditing || isSelected
    }
    
    // MARK: Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initValidationTextField()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initValidationTextField()
    }
    
    private func initValidationTextField() {
        borderStyle = .none
        self.createTitleLabel()
        self.createLineView()
        self.addEditingChangedObserver()
    }
    
    private func addEditingChangedObserver(){
        self.addTarget(self, action: #selector(self.editingChanged), for: [.editingChanged])
    }
    
    @objc
    private func editingChanged() {
        if let isValid = validCondition?(self.text ?? ""), !isValid {
            self.isValid = isValid
            _errorMessage = errorMessage
        } else {
            self.isValid = true
            _errorMessage = nil
        }
        
        update()
        
        self.updateTitleVisibility(true)
    }

    private func createTitleLabel() {
        let titleLabel = UILabel()
        
        titleLabel.autoresizingMask = [.flexibleWidth,. flexibleHeight]
        titleLabel.font = completedTitleFont
        titleLabel.alpha = 0.0
        titleLabel.textColor = completedColor
        
        addSubview(titleLabel)
        self.titleLabel = titleLabel
    }
    
    private func createLineView() {
        if self.lineView == nil {
            let lineView = UIView()
            lineView.isUserInteractionEnabled = false
            self.lineView = lineView
            self.lineView.backgroundColor = baseColor
            self.configureDefaultLineHeight()
        }
        
        lineView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        addSubview(lineView)
    }
    
    private func titleHeight() -> CGFloat {
        if let titleLabel = titleLabel,
            let font = titleLabel.font {
            return font.lineHeight
        }
        return 15.0
    }
    
    private func configureDefaultLineHeight() {
        let pixel: CGFloat = 1.0 / UIScreen.main.scale
        self.lineHeight = 2.0 * pixel
        self.selectedLineHeight = 2.0 * self.lineHeight
    }
    
    private func titleLabelRectForBounds(_ bounds: CGRect, editing: Bool) -> CGRect {
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
    
    private func lineViewRectForBounds(_ bounds: CGRect, editing: Bool) -> CGRect {
        let height = editing ? selectedLineHeight : lineHeight
        
        return CGRect(
            x: 0,
            y: bounds.size.height - height,
            width: bounds.size.width,
            height: height
        )
    }
    
    private func textHeight() -> CGFloat {
        guard let font = self.font else { return 0.0 }
        
        return font.lineHeight + 7.0
    }
    
    private func updateTitleVisibility(_ animated: Bool = false) {
        let alpha: CGFloat = self.isTitleVisible ? 1.0 : 0.0
        let frame = titleLabelRectForBounds(bounds, editing: isTitleVisible)
        
        let updateBlock = {() -> Void in
            self.titleLabel.alpha = alpha
            self.titleLabel.frame = frame
        }
        
        if animated {
            #if swift(>=4.2)
            let animationOptions: UIView.AnimationOptions = .curveEaseOut
            #else
            let animationOptions: UIViewAnimationOptions = .curveEaseOut
            #endif
            
            let duration = isTitleVisible ? titleFadeInDuration : titleFadeOutDuration
            
            UIView.animate(withDuration: duration, delay: 0, options: animationOptions, animations: { () -> Void in
                updateBlock()
            }, completion: nil)
        } else {
            
        }
    }
    
    private func update(){
        if hasErrorMessage{
            titleLabel.text = errorMessage
            titleLabel.textColor = errorColor
            lineView.backgroundColor = errorColor
        } else if editingOrSelected {
            titleLabel.text = completedTitleText
            titleLabel.textColor = completedColor
            lineView.backgroundColor = completedColor
        } else {
            titleLabel.text = completedTitleText
            titleLabel.textColor = completedColor
            lineView.backgroundColor = baseColor
        }
        
        updateTitleVisibility(true)
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
        
        return CGRect(
            x: superRect.origin.x,
            y: titleHeight,
            width: superRect.size.width,
            height: superRect.size.height - titleHeight - selectedLineHeight
        )
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let rect = CGRect(
            x: 0,
            y: titleHeight(),
            width: bounds.size.width,
            height: bounds.size.height - titleHeight() - selectedLineHeight
        )
        return rect
    }
    
    override open func prepareForInterfaceBuilder() {
        if #available(iOS 8.0, *) {
            super.prepareForInterfaceBuilder()
        }
        
        borderStyle = .none
        
        isSelected = true
        invalidateIntrinsicContentSize()
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.frame = self.titleLabelRectForBounds(
            bounds,
            editing: self.isTitleVisible
        )
        
        lineView.frame = self.lineViewRectForBounds(
            bounds,
            editing: self.editingOrSelected
        )
    }
    
    override open var intrinsicContentSize: CGSize {
        return CGSize(width: bounds.size.width, height: titleHeight() + textHeight())
    }
}
