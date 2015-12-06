//
//  PeriscopyNavBarExtension.swift
//  PeriscopyPullToRefresh
//
//  Created by Andrzej Naglik on 02.09.2015.
//  Copyright © 2015 Andrzej Naglik. All rights reserved.
//

import UIKit

extension UINavigationBar{
  
  func stripeImage()->UIImage{
    UIGraphicsBeginImageContextWithOptions(CGSize(width: 32, height: 44), false, 0)
    let context = UIGraphicsGetCurrentContext()
    
    // Gradient
    let gradientColor = UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 0.0800)
    let gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), [gradientColor.CGColor, UIColor.clearColor().CGColor], [0, 0.86])!
    
    // Bezier
    let bezierPath = UIBezierPath()
    bezierPath.moveToPoint(CGPointMake(0.0, 44.0))
    bezierPath.addLineToPoint(CGPointMake(18.5, 0.0))
    bezierPath.addLineToPoint(CGPointMake(31.5, 0.0))
    bezierPath.addLineToPoint(CGPointMake(13.5, 44.0))
    bezierPath.addLineToPoint(CGPointMake(0.0, 44.0))
    bezierPath.closePath()
    CGContextSaveGState(context)
    bezierPath.addClip()
    CGContextDrawLinearGradient(context, gradient, CGPointMake(-2.5, 40.5), CGPointMake(34.5, 3.5), CGGradientDrawingOptions())
    CGContextRestoreGState(context)
    let imageToReturn = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return imageToReturn
  }
  
  
  func startLoadingAnimation() -> UIView{
    let image = stripeImage()
    let extraWidth = (image.size.width) * 8 //adding 8 additional stripes

    let animatedView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: CGRectGetWidth(self.frame) + extraWidth, height: CGRectGetHeight(self.frame)))
    animatedView.backgroundColor = UIColor(patternImage: image)
    animatedView.opaque = false
    self.insertSubview(animatedView, atIndex: 1)
    
    UIView.animateWithDuration(2.0, delay: 0.0, options: [.Repeat, .CurveLinear] , animations: {
      animatedView.frame.origin.x -= extraWidth
      }, completion: nil)
    
    return animatedView
  }
  
  func stopLoadingAnimationWithView(view: UIView){
    UIView.animateWithDuration(1.0, animations: {
      view.alpha = 0.0
      }) { [weak view] (completed) -> Void in
        if let animatedView = view{
          animatedView.layer.removeAllAnimations()
          animatedView.removeFromSuperview()
        }
        
    }
  }
}
