//
//  TitleView.swift
//  PeriscopyPullToRefresh
//
//  Created by Andrzej Naglik on 28.08.2015.
//  Copyright © 2015 Andrzej Naglik. All rights reserved.
//

import UIKit

private var KVOContext = "KVOContext"
private let kContentOffsetKey = "contentOffset"
private let labelsDistance :CGFloat = 21.0

public class PeriscopyTitleView: UIView {
  let titleLabel: UILabel
  let releaseLabel: UILabel
  
  
  private var titlePositionConstraint : NSLayoutConstraint?
  private var previousYPosition : CGFloat
  private let refreshCallback : ()->Void
  private var shouldRefresh: Bool
  
  weak var scrollingView : UIScrollView? {
    willSet(newScrollView){
      //remove observer if needed
      stopObservingCurrentScrollView()
      startObservingScrollView(newScrollView!)
    }
  }
  
  private let gradientLayer = CAGradientLayer()
  
  init(frame: CGRect, attachToScrollView scrollView: UIScrollView, refreshAction: () -> Void) {
    titleLabel = UILabel(frame: CGRect.zero)
    releaseLabel = UILabel(frame: CGRect.zero)
    previousYPosition = 0.0
    shouldRefresh = false
    refreshCallback = refreshAction
    super.init(frame: frame)
    autoresizingMask = .FlexibleHeight
    
    scrollingView = scrollView
    startObservingScrollView(scrollingView!)
    
    self.addSubview(titleLabel)
    self.addSubview(releaseLabel)
    setupDefaultUI()
    setupConstraints()
    applyViewMask()
  }

  required public init(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  deinit{
    stopObservingCurrentScrollView()
  }
  
  private func setupDefaultUI(){
    releaseLabel.text = NSLocalizedString("发现更多", comment: "")
    releaseLabel.highlightedTextColor = UIColor(red:207/255.0, green:240/255, blue:158/255, alpha:1.0)
    
    titleLabel.textAlignment = NSTextAlignment.Center
    releaseLabel.textAlignment = NSTextAlignment.Center
  }
  
  override public func layoutSubviews() {
    super.layoutSubviews()
    gradientLayer.frame = self.bounds
  }
  
  func setupConstraints(){
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    releaseLabel.translatesAutoresizingMaskIntoConstraints = false
    
    let viewsArray = ["titleLabel" : titleLabel, "releaseLabel" : releaseLabel]
    let metricsArray = ["distance" : labelsDistance]
    
    titlePositionConstraint = NSLayoutConstraint(item: titleLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal,
                                               toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0)
    self.addConstraint(titlePositionConstraint!)

    self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[titleLabel(==releaseLabel)]|",
                                                                      options: NSLayoutFormatOptions(rawValue: 0) , metrics: nil, views: viewsArray))
    self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[releaseLabel]-(distance)-[titleLabel]",
                                                                      options: .AlignAllCenterX, metrics: metricsArray, views: viewsArray))
    
  }
  
  func applyViewMask(){
    gradientLayer.colors = [UIColor.clearColor().CGColor,UIColor.whiteColor().CGColor,UIColor.whiteColor().CGColor,UIColor.clearColor().CGColor]
    gradientLayer.locations = [0.0,0.3,0.8,1.0]
    self.layer.mask = gradientLayer
  }
  
  override public func willMoveToSuperview(newSuperview: UIView?) {
    super.willMoveToSuperview(newSuperview)
    if let superview = newSuperview as? UINavigationBar{
      if((titleLabel.text) == nil){
        titleLabel.text = superview.topItem?.title
      }
    }
  }
  
  func startObservingScrollView(scrollView:UIScrollView){
    scrollView.addObserver(self, forKeyPath: kContentOffsetKey, options: .New, context: &KVOContext)
  }
  
  func stopObservingCurrentScrollView(){
    if let scrollingView = self.scrollingView{
      scrollingView.removeObserver(self, forKeyPath: kContentOffsetKey, context: &KVOContext)
    }
  }
  
  override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
    if(context != &KVOContext){
      super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
    }
    
    if let scrollView = object as? UIScrollView{
      var point = scrollView.contentOffset.y + scrollView.contentInset.top
      
      let draggingLimit = CGFloat(labelsDistance + CGRectGetHeight(releaseLabel.frame)) * -1
      
      if(point == 0){
        shouldRefresh = false
      }else if(point > 0){
        point = 0.0
        previousYPosition = point
      }else if(point <= draggingLimit){
        releaseLabel.highlighted = true;
        point = draggingLimit
        
        if(!shouldRefresh && scrollView.decelerating && previousYPosition == draggingLimit){//
          refreshCallback()
          shouldRefresh = true
        }
        
        previousYPosition = point
        
      }else{
        releaseLabel.highlighted = false;
        if(!shouldRefresh && scrollView.decelerating && previousYPosition == draggingLimit){//
          refreshCallback()
          shouldRefresh = true
        }
        previousYPosition = point
      }
      
      titlePositionConstraint?.constant = (-point)
    }
  }
}

