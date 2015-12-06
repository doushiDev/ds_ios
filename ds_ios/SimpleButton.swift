//
//  SimpleButton.swift
//  Example
//
//  Created by Andreas Tinoco Lobo on 25.03.15.
//  Copyright (c) 2015 Andreas Tinoco Lobo. All rights reserved.
//

import UIKit

@IBDesignable
public class SimpleButton: UIButton {
    
    typealias ControlState = UInt
    
    public var animationDuration: NSTimeInterval = 0.1
    public var animateStateChange: Bool = true
    
    lazy private var backgroundColors = [ControlState: CGColor]()
    lazy private var borderColors = [ControlState: CGColor]()
    lazy private var buttonScales = [ControlState: CGFloat]()
    lazy private var borderWidths = [ControlState: CGFloat]()
    lazy private var cornerRadii = [ControlState: CGFloat]()
    
    lazy private var shadowColors = [ControlState: CGColor]()
    lazy private var shadowOpacity = [ControlState: Float]()
    lazy private var shadowOffset = [ControlState: CGSize]()
    lazy private var shadowRadii = [ControlState: CGFloat]()

    override public var enabled: Bool {
        didSet {
            updateForStateChange(animateStateChange)
        }
    }
    
    override public var highlighted: Bool {
        didSet {
            updateForStateChange(animateStateChange)
        }
    }
    
    override public var selected: Bool {
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
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        configureButtonStyles()
    }
    #endif
    
    public override func prepareForInterfaceBuilder() {
        configureButtonStyles()
    }
    
    // MARK: Configuration
    
    public func configureButtonStyles() {
        translatesAutoresizingMaskIntoConstraints = false
        buttonScales[UIControlState.Normal.rawValue] = 1.0
        backgroundColors[UIControlState.Normal.rawValue] = backgroundColor?.CGColor
        borderColors[UIControlState.Normal.rawValue] = layer.borderColor
        borderWidths[UIControlState.Normal.rawValue] = layer.borderWidth
        cornerRadii[UIControlState.Normal.rawValue] = layer.cornerRadius
        shadowColors[UIControlState.Normal.rawValue] = layer.shadowColor
        shadowOpacity[UIControlState.Normal.rawValue] = layer.shadowOpacity
        shadowOffset[UIControlState.Normal.rawValue] = layer.shadowOffset
        shadowRadii[UIControlState.Normal.rawValue] = layer.shadowRadius
    }
    
    public func setScale(scale: CGFloat, forState state: UIControlState = .Normal, animated: Bool = false) {
        buttonScales[state.rawValue] = scale
        changeScaleForStateChange(animated)
    }
    
    public func setBackgroundColor(color: UIColor, forState state: UIControlState = .Normal, animated: Bool = false) {
        backgroundColors[state.rawValue] = color.CGColor
        changeBackgroundColorForStateChange(animated)
    }
    
    public func setBorderWidth(width: CGFloat, forState state: UIControlState = .Normal, animated: Bool = false) {
        borderWidths[state.rawValue] = width
        changeBorderWidthForStateChange(animated)
    }
    
    public func setBorderColor(color: UIColor, forState state: UIControlState = .Normal, animated: Bool = false) {
        borderColors[state.rawValue] = color.CGColor
        changeBorderColorForStateChange(animated)
    }
    
    public func setCornerRadius(radius: CGFloat, forState state: UIControlState = .Normal, animated: Bool = false) {
        cornerRadii[state.rawValue] = radius
        changeCornerRadiusForStateChange(animated)
    }
    
    public func setShadowColor(color: UIColor, forState state: UIControlState = .Normal, animated: Bool = false) {
        shadowColors[state.rawValue] = color.CGColor
        changeShadowColorForStateChange(animated)
    }

    public func setShadowOpacity(opacity: Float, forState state: UIControlState = .Normal, animated: Bool = false) {
        shadowOpacity[state.rawValue] = opacity
        changeShadowOpacityForStateChange(animated)
    }

    public func setShadowRadius(radius: CGFloat, forState state: UIControlState = .Normal, animated: Bool = false) {
        shadowRadii[state.rawValue] = radius
        changeShadowRadiusForStateChange(animated)
    }
    
    public func setShadowOffset(offset: CGSize, forState state: UIControlState = .Normal, animated: Bool = false) {
        shadowOffset[state.rawValue] = offset
        changeShadowOffsetForStateChange(animated)
    }
    
    // MARK: Helper
    
    public func setTitleImageSpacing(spacing: CGFloat) {
        imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing);
        titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
    }
    
    // MARK: Private Animation Helpers
    
    private func updateForStateChange(animated: Bool) {
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
    
    private func changeCornerRadiusForStateChange(animated: Bool = false) {
        if let radius = cornerRadii[state.rawValue] ?? cornerRadii[UIControlState.Normal.rawValue] where radius != layer.cornerRadius {
            if animated {
                animateLayer(layer, from: layer.cornerRadius, to: radius, forKey: "cornerRadius")
            }
            layer.cornerRadius = radius
        }
    }
    
    private func changeScaleForStateChange(animated: Bool = false) {
        if let scale = buttonScales[state.rawValue] ?? buttonScales[UIControlState.Normal.rawValue] where transform.a != scale && transform.b != scale {
            let animations = {
                self.transform = CGAffineTransformMakeScale(scale, scale)
            }
            animated ? UIView.animateWithDuration(animationDuration, animations: animations) : animations()
        }
    }
    
    private func changeBackgroundColorForStateChange(animated: Bool = false) {
        if let color = backgroundColors[state.rawValue] ?? backgroundColors[UIControlState.Normal.rawValue] where layer.backgroundColor == nil || UIColor(CGColor: layer.backgroundColor!) != UIColor(CGColor: color) {
            if animated {
                animateLayer(layer, from: layer.backgroundColor, to: color, forKey: "backgroundColor")
            }
            layer.backgroundColor = color
        }
    }
    
    private func changeBorderColorForStateChange(animated: Bool = false) {
        if let color = borderColors[state.rawValue] ?? borderColors[UIControlState.Normal.rawValue] where layer.borderColor == nil || UIColor(CGColor: layer.borderColor!) != UIColor(CGColor: color)  {
            if animated {
                animateLayer(layer, from: layer.borderColor, to: color, forKey: "borderColor")
            }
            layer.borderColor = color
        }
    }
    
    private func changeBorderWidthForStateChange(animated: Bool = false) {
        if let width = borderWidths[state.rawValue] ?? borderWidths[UIControlState.Normal.rawValue] where width != layer.borderWidth {
            if animated {
                animateLayer(layer, from: layer.borderWidth, to: width, forKey: "borderWidth")
            }
            layer.borderWidth = width
        }
    }
    
    private func changeShadowOffsetForStateChange(animated: Bool = false) {
        if let offset = shadowOffset[state.rawValue] ?? shadowOffset[UIControlState.Normal.rawValue] where offset != layer.shadowOffset {
            if animated {
                animateLayer(layer, from: NSValue(CGSize: layer.shadowOffset), to: NSValue(CGSize: offset), forKey: "shadowOffset")
            }
            layer.shadowOffset = offset
        }
    }
    
    private func changeShadowColorForStateChange(animated: Bool = false) {
        if let color = shadowColors[state.rawValue] ?? shadowColors[UIControlState.Normal.rawValue] where layer.shadowColor == nil || UIColor(CGColor: layer.shadowColor!) != UIColor(CGColor: color)  {
            if animated {
                animateLayer(layer, from: layer.shadowColor, to: color, forKey: "shadowColor")
            }
            layer.shadowColor = color
        }
    }
    
    private func changeShadowRadiusForStateChange(animated: Bool = false) {
        if let radius = shadowRadii[state.rawValue] ?? shadowRadii[UIControlState.Normal.rawValue] where radius != layer.shadowRadius {
            if animated {
                animateLayer(layer, from: layer.shadowRadius, to: radius, forKey: "shadowRadius")
            }
            
            layer.shadowRadius = radius
        }
    }
    
    private func changeShadowOpacityForStateChange(animated: Bool = false) {
        if let opacity = shadowOpacity[state.rawValue] ?? shadowOpacity[UIControlState.Normal.rawValue] where opacity != layer.shadowOpacity {
            if animated {
                animateLayer(layer, from: layer.shadowOpacity, to: opacity, forKey: "shadowOpacity")
            }
            
            layer.shadowOpacity = opacity
        }
    }
    
    private func animateLayer(layer: CALayer, from: AnyObject?, to: AnyObject, forKey key: String) {
        let animation = CABasicAnimation()
        animation.fromValue = from
        animation.toValue = to
        animation.duration = animationDuration
        layer.addAnimation(animation, forKey: key)
    }
}
