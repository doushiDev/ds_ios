//
//  CustomButtons.swift
//  Example
//
//  Created by Andreas Tinoco Lobo on 08.04.15.
//  Copyright (c) 2015 Andreas Tinoco Lobo. All rights reserved.
//

import Foundation
import UIKit


@IBDesignable
class ScaleButton: SimpleButton {
    override func configureButtonStyles() {
        super.configureButtonStyles()
        setBackgroundColor(UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0), forState: UIControlState())
        setTitle(".Normal", for: UIControlState())
        setTitle(".Highlighted", for: .highlighted)
        setScale(0.97, forState: .highlighted)
        
    }
}

@IBDesignable
class BackgroundColorButton: SimpleButton {
    override func configureButtonStyles() {
        super.configureButtonStyles()
        
        setScale(0.98, forState: .highlighted, animated: true)
        setShadowRadius(5, forState: UIControlState(), animated: true)
        setShadowRadius(10, forState: .highlighted, animated: true)
        setShadowOpacity(0.6, forState: UIControlState())
        setShadowOpacity(0.6, forState: .highlighted)
        setShadowOffset(CGSize(width: 0, height: 1), forState: UIControlState())
        setShadowOffset(CGSize(width: 0, height: 2), forState: .highlighted)
//        setBackgroundColor(UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1.0), forState: .Normal)
        setBackgroundColor(UIColor(rgba:"#f0a22a"))
//        setBackgroundColor(UIColor(red: 211/255, green: 84/255, blue: 0/255, alpha: 1.0), forState: .Highlighted)
        setTitle("获取验证码", for: UIControlState())
//        setTitle(".Highlighted", forState: .Highlighted)
        
    }
}

@IBDesignable
class BorderWidthButton: SimpleButton {
    override func configureButtonStyles() {
        super.configureButtonStyles()
        setTitleColor(UIColor(red: 155/255, green: 89/255, blue: 182/255, alpha: 1.0), for: UIControlState())
        setBorderColor(UIColor(red: 155/255, green: 89/255, blue: 182/255, alpha: 1.0), forState: UIControlState())
        setTitle(".Normal", for: UIControlState())
        setTitle(".Highlighted", for: .highlighted)
        setBorderWidth(2.0, forState: UIControlState())
        setBorderWidth(8.0, forState: .highlighted)
        
    }
}

@IBDesignable
class BorderColorButton: SimpleButton {
    override func configureButtonStyles() {
        super.configureButtonStyles()
        setTitleColor(UIColor.gray, for: UIControlState())
        setBorderWidth(4.0, forState: UIControlState())
        setBorderColor(UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0), forState: UIControlState())
        setBorderColor(UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0), forState: .highlighted)
        setTitle(".Normal", for: UIControlState())
        setTitle(".Highlighted", for: .highlighted)
        
    }
}

@IBDesignable
class CornerRadiusButton: SimpleButton {
    override func configureButtonStyles() {
        super.configureButtonStyles()
        setBackgroundColor(UIColor(rgba:"#f0a22a"), forState: UIControlState())
        setTitle("登录", for: UIControlState())
//        setTitle(".Highlighted", forState: .Highlighted)
        setCornerRadius(10.0, forState: UIControlState())
//        setCornerRadius(20.0, forState: .Highlighted)

    }
}

@IBDesignable
class CornerRadiusButtonByRes: SimpleButton {
    override func configureButtonStyles() {
        super.configureButtonStyles()
//        setBackgroundColor(UIColor(red: 26/255, green: 188/255, blue: 156/255, alpha: 1.0), forState: .Normal)
        setBackgroundColor(UIColor(rgba:"#f0a22a"), forState: UIControlState())

        
        setTitle("注册", for: UIControlState())
        //        setTitle(".Highlighted", forState: .Highlighted)
        setCornerRadius(10.0, forState: UIControlState())
        //        setCornerRadius(20.0, forState: .Highlighted)
        
    }
}

@IBDesignable
class CornerRadiusButtonByCode: SimpleButton {
    override func configureButtonStyles() {
        super.configureButtonStyles()
        setBackgroundColor(UIColor(rgba:"#f0a22a"), forState: UIControlState())
        setTitle("获取验证码", for: UIControlState())
        //        setTitle(".Highlighted", forState: .Highlighted)
        setCornerRadius(10.0, forState: UIControlState())
        //        setCornerRadius(20.0, forState: .Highlighted)
        
    }
}


@IBDesignable
class CornerRadiusButtonByHeadImage: SimpleButton {
    override func configureButtonStyles() {
        super.configureButtonStyles()
        //        setBackgroundColor(UIColor(red: 26/255, green: 188/255, blue: 156/255, alpha: 1.0), forState: .Normal)
        setBackgroundColor(UIColor(rgba:"#f0a22a"), forState: UIControlState())
        
        
//        setTitle("注册", forState: .Normal)
        //        setTitle(".Highlighted", forState: .Highlighted)
        setCornerRadius(10.0, forState: UIControlState())
        //        setCornerRadius(20.0, forState: .Highlighted)
        
    }
}



