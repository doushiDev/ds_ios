//
//  RoundImageView.swift
//  Quotes
//
//  Created by Rafael Veronezi on 3/31/15.
//  Copyright (c) 2015 Ravero. All rights reserved.
//

import UIKit

@IBDesignable open class RoundImageView: UIImageView {

    //
    // MARK: - Properties
    
    @IBInspectable open var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable open var borderColor: UIColor = UIColor.black {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    //
    // MARK: - Constructors
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override public init(image: UIImage!) {
        super.init(image: image)
        setup()
    }
    
    override public init(image: UIImage!, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
        setup()
    }
    
    //
    // MARK: - Support Methods
    
    func setup() {
        self.layer.cornerRadius = self.bounds.size.width / 2
        self.layer.masksToBounds = true
    }
    
    override open func prepareForInterfaceBuilder() {
        setup()
    }

}
