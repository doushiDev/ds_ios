//
//  SimpleButton.swift
//  Example
//
//  Created by Andreas Tinoco Lobo on 25.03.15.
//  Copyright (c) 2015 Andreas Tinoco Lobo. All rights reserved.
//

import UIKit

@IBDesignable
open class SimpleButton: UIButton {
    
    typealias ControlState = UInt
    
    open var animationDuration: TimeInterval = 0.1
    open var animateStateChange: Bool = true
    
    lazy fileprivate var backgroundColors = [ControlState: CGColor]()
    lazy fileprivate var borderColors = [ControlState: CGColor]()
    lazy fileprivate var buttonScales = [ControlState: CGFloat]()
    lazy fileprivate var borderWidths = [ControlState: CGFloat]()
    lazy fileprivate var cornerRadii = [ControlState: CGFloat]()
    
    lazy fileprivate var shadowColors = [ControlState: CGColor]()
    lazy fileprivate var shadowOpacity = [ControlState: Float]()
    lazy fileprivate var shadowOffset = [ControlState: CGSize]()
    lazy fileprivate var shadowRadii = [ControlState: CGFloat]()

    override open var isEnabled: Bool {
        didSet {
            updateForStateChange(animateStateChange)
        }
    }
    
    override open var isHighlighted: Bool {
        didSet {
            updateForStateChange(animateStateChange)
        }
    }
    
    override open var isSelected: Bool {
        didSet {
            updateForStateChange(animateStateChange)
        }
    }
    
    // MARK: IBInspectable
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            setCornerRadius(cornerRadius)
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            setBorderWidth(borderWidth)
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            if borderColor != nil {
                setBorderColor(borderColor!)
            }
        }
    }
    
    // MARK: Initializer
    
    #if !TARGET_INTERFACE_BUILDER
    required override public init(frame: CGRect) {
        super.init(frame: frame)
        configureButtonStyles()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureButtonStyles()
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        configureButtonStyles()
    }
    #endif
    
    open override func prepareForInterfaceBuilder() {
        configureButtonStyles()
    }
    
    // MARK: Configuration
    
    open func configureButtonStyles() {
        translatesAutoresizingMaskIntoConstraints = false
        buttonScales[UIControlState().rawValue] = 1.0
        backgroundColors[UIControlState().rawValue] = backgroundColor?.cgColor
        borderColors[UIControlState().rawValue] = layer.borderColor
        borderWidths[UIControlState().rawValue] = layer.borderWidth
        cornerRadii[UIControlState().rawValue] = layer.cornerRadius
        shadowColors[UIControlState().rawValue] = layer.shadowColor
        shadowOpacity[UIControlState().rawValue] = layer.shadowOpacity
        shadowOffset[UIControlState().rawValue] = layer.shadowOffset
        shadowRadii[UIControlState().rawValue] = layer.shadowRadius
    }
    
    open func setScale(_ scale: CGFloat, forState state: UIControlState = UIControlState(), animated: Bool = false) {
        buttonScales[state.rawValue] = scale
        changeScaleForStateChange(animated)
    }
    
    open func setBackgroundColor(_ color: UIColor, forState state: UIControlState = UIControlState(), animated: Bool = false) {
        backgroundColors[state.rawValue] = color.cgColor
        changeBackgroundColorForStateChange(animated)
    }
    
    open func setBorderWidth(_ width: CGFloat, forState state: UIControlState = UIControlState(), animated: Bool = false) {
        borderWidths[state.rawValue] = width
        changeBorderWidthForStateChange(animated)
    }
    
    open func setBorderColor(_ color: UIColor, forState state: UIControlState = UIControlState(), animated: Bool = false) {
        borderColors[state.rawValue] = color.cgColor
        changeBorderColorForStateChange(animated)
    }
    
    open func setCornerRadius(_ radius: CGFloat, forState state: UIControlState = UIControlState(), animated: Bool = false) {
        cornerRadii[state.rawValue] = radius
        changeCornerRadiusForStateChange(animated)
    }
    
    open func setShadowColor(_ color: UIColor, forState state: UIControlState = UIControlState(), animated: Bool = false) {
        shadowColors[state.rawValue] = color.cgColor
        changeShadowColorForStateChange(animated)
    }

    open func setShadowOpacity(_ opacity: Float, forState state: UIControlState = UIControlState(), animated: Bool = false) {
        shadowOpacity[state.rawValue] = opacity
        changeShadowOpacityForStateChange(animated)
    }

    open func setShadowRadius(_ radius: CGFloat, forState state: UIControlState = UIControlState(), animated: Bool = false) {
        shadowRadii[state.rawValue] = radius
        changeShadowRadiusForStateChange(animated)
    }
    
    open func setShadowOffset(_ offset: CGSize, forState state: UIControlState = UIControlState(), animated: Bool = false) {
        shadowOffset[state.rawValue] = offset
        changeShadowOffsetForStateChange(animated)
    }
    
    // MARK: Helper
    
    open func setTitleImageSpacing(_ spacing: CGFloat) {
        imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing);
        titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
    }
    
    // MARK: Private Animation Helpers
    
    fileprivate func updateForStateChange(_ animated: Bool) {
        changeBackgroundColorForStateChange(animated)
        changeBorderColorForStateChange(animated)
        changeScaleForStateChange(animated)
        changeBorderWidthForStateChange(animated)
        changeCornerRadiusForStateChange(animated)
        changeShadowOffsetForStateChange(animated)
        changeShadowColorForStateChange(animated)
        changeShadowOpacityForStateChange(animated)
        changeShadowRadiusForStateChange(animated)
    }
    
    fileprivate func changeCornerRadiusForStateChange(_ animated: Bool = false) {
        if let radius = cornerRadii[state.rawValue] ?? cornerRadii[UIControlState().rawValue] , radius != layer.cornerRadius {
            if animated {
                animateLayer(layer, from: layer.cornerRadius as AnyObject?, to: radius as AnyObject, forKey: "cornerRadius")
            }
            layer.cornerRadius = radius
        }
    }
    
    fileprivate func changeScaleForStateChange(_ animated: Bool = false) {
        if let scale = buttonScales[state.rawValue] ?? buttonScales[UIControlState().rawValue] , transform.a != scale && transform.b != scale {
            let animations = {
                self.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
            animated ? UIView.animate(withDuration: animationDuration, animations: animations) : animations()
        }
    }
    
    fileprivate func changeBackgroundColorForStateChange(_ animated: Bool = false) {
        if let color = backgroundColors[state.rawValue] ?? backgroundColors[UIControlState().rawValue] , layer.backgroundColor == nil || UIColor(cgColor: layer.backgroundColor!) != UIColor(cgColor: color) {
            if animated {
                animateLayer(layer, from: layer.backgroundColor, to: color, forKey: "backgroundColor")
            }
            layer.backgroundColor = color
        }
    }
    
    fileprivate func changeBorderColorForStateChange(_ animated: Bool = false) {
        if let color = borderColors[state.rawValue] ?? borderColors[UIControlState().rawValue] , layer.borderColor == nil || UIColor(cgColor: layer.borderColor!) != UIColor(cgColor: color)  {
            if animated {
                animateLayer(layer, from: layer.borderColor, to: color, forKey: "borderColor")
            }
            layer.borderColor = color
        }
    }
    
    fileprivate func changeBorderWidthForStateChange(_ animated: Bool = false) {
        if let width = borderWidths[state.rawValue] ?? borderWidths[UIControlState().rawValue] , width != layer.borderWidth {
            if animated {
                animateLayer(layer, from: layer.borderWidth as AnyObject?, to: width as AnyObject, forKey: "borderWidth")
            }
            layer.borderWidth = width
        }
    }
    
    fileprivate func changeShadowOffsetForStateChange(_ animated: Bool = false) {
        if let offset = shadowOffset[state.rawValue] ?? shadowOffset[UIControlState().rawValue] , offset != layer.shadowOffset {
            if animated {
                animateLayer(layer, from: NSValue(cgSize: layer.shadowOffset), to: NSValue(cgSize: offset), forKey: "shadowOffset")
            }
            layer.shadowOffset = offset
        }
    }
    
    fileprivate func changeShadowColorForStateChange(_ animated: Bool = false) {
        if let color = shadowColors[state.rawValue] ?? shadowColors[UIControlState().rawValue] , layer.shadowColor == nil || UIColor(cgColor: layer.shadowColor!) != UIColor(cgColor: color)  {
            if animated {
                animateLayer(layer, from: layer.shadowColor, to: color, forKey: "shadowColor")
            }
            layer.shadowColor = color
        }
    }
    
    fileprivate func changeShadowRadiusForStateChange(_ animated: Bool = false) {
        if let radius = shadowRadii[state.rawValue] ?? shadowRadii[UIControlState().rawValue] , radius != layer.shadowRadius {
            if animated {
                animateLayer(layer, from: layer.shadowRadius as AnyObject?, to: radius as AnyObject, forKey: "shadowRadius")
            }
            
            layer.shadowRadius = radius
        }
    }
    
    fileprivate func changeShadowOpacityForStateChange(_ animated: Bool = false) {
        if let opacity = shadowOpacity[state.rawValue] ?? shadowOpacity[UIControlState().rawValue] , opacity != layer.shadowOpacity {
            if animated {
                animateLayer(layer, from: layer.shadowOpacity as AnyObject?, to: opacity as AnyObject, forKey: "shadowOpacity")
            }
            
            layer.shadowOpacity = opacity
        }
    }
    
    fileprivate func animateLayer(_ layer: CALayer, from: AnyObject?, to: AnyObject, forKey key: String) {
        let animation = CABasicAnimation()
        animation.fromValue = from
        animation.toValue = to
        animation.duration = animationDuration
        layer.add(animation, forKey: key)
    }
}
