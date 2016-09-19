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

open class PeriscopyTitleView: UIView {
  let titleLabel: UILabel
  let releaseLabel: UILabel
  
  
  fileprivate var titlePositionConstraint : NSLayoutConstraint?
  fileprivate var previousYPosition : CGFloat
  fileprivate let refreshCallback : ()->Void
  fileprivate var shouldRefresh: Bool
  
  weak var scrollingView : UIScrollView? {
    willSet(newScrollView){
      //remove observer if needed
      stopObservingCurrentScrollView()
      startObservingScrollView(newScrollView!)
    }
  }
  
  fileprivate let gradientLayer = CAGradientLayer()
  
  init(frame: CGRect, attachToScrollView scrollView: UIScrollView, refreshAction: @escaping () -> Void) {
    titleLabel = UILabel(frame: CGRect.zero)
    releaseLabel = UILabel(frame: CGRect.zero)
    previousYPosition = 0.0
    shouldRefresh = false
    refreshCallback = refreshAction
    super.init(frame: frame)
    autoresizingMask = .flexibleHeight
    
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
  
  fileprivate func setupDefaultUI(){
    releaseLabel.text = NSLocalizedString("发现更多", comment: "")
    releaseLabel.highlightedTextColor = UIColor(red:207/255.0, green:240/255, blue:158/255, alpha:1.0)
    
    titleLabel.textAlignment = NSTextAlignment.center
    releaseLabel.textAlignment = NSTextAlignment.center
  }
  
  override open func layoutSubviews() {
    super.layoutSubviews()
    gradientLayer.frame = self.bounds
  }
  
  func setupConstraints(){
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    releaseLabel.translatesAutoresizingMaskIntoConstraints = false
    
    let viewsArray = ["titleLabel" : titleLabel, "releaseLabel" : releaseLabel]
    let metricsArray = ["distance" : labelsDistance]
    
    titlePositionConstraint = NSLayoutConstraint(item: titleLabel, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal,
                                               toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1.0, constant: 0.0)
    self.addConstraint(titlePositionConstraint!)

    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[titleLabel(==releaseLabel)]|",
                                                                      options: NSLayoutFormatOptions(rawValue: 0) , metrics: nil, views: viewsArray))
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[releaseLabel]-(distance)-[titleLabel]",
                                                                      options: .alignAllCenterX, metrics: metricsArray, views: viewsArray))
    
  }
  
  func applyViewMask(){
    gradientLayer.colors = [UIColor.clear.cgColor,UIColor.white.cgColor,UIColor.white.cgColor,UIColor.clear.cgColor]
    gradientLayer.locations = [0.0,0.3,0.8,1.0]
    self.layer.mask = gradientLayer
  }
  
  override open func willMove(toSuperview newSuperview: UIView?) {
    super.willMove(toSuperview: newSuperview)
    if let superview = newSuperview as? UINavigationBar{
      if((titleLabel.text) == nil){
        titleLabel.text = superview.topItem?.title
      }
    }
  }
  
  func startObservingScrollView(_ scrollView:UIScrollView){
    scrollView.addObserver(self, forKeyPath: kContentOffsetKey, options: .new, context: &KVOContext)
  }
  
  func stopObservingCurrentScrollView(){
    if let scrollingView = self.scrollingView{
      scrollingView.removeObserver(self, forKeyPath: kContentOffsetKey, context: &KVOContext)
    }
  }
  
  override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if(context != &KVOContext){
      super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
    }
    
    if let scrollView = object as? UIScrollView{
      var point = scrollView.contentOffset.y + scrollView.contentInset.top
      
      let draggingLimit = CGFloat(labelsDistance + releaseLabel.frame.height) * -1
      
      if(point == 0){
        shouldRefresh = false
      }else if(point > 0){
        point = 0.0
        previousYPosition = point
      }else if(point <= draggingLimit){
        releaseLabel.isHighlighted = true;
        point = draggingLimit
        
        if(!shouldRefresh && scrollView.isDecelerating && previousYPosition == draggingLimit){//
          refreshCallback()
          shouldRefresh = true
        }
        
        previousYPosition = point
        
      }else{
        releaseLabel.isHighlighted = false;
        if(!shouldRefresh && scrollView.isDecelerating && previousYPosition == draggingLimit){//
          refreshCallback()
          shouldRefresh = true
        }
        previousYPosition = point
      }
      
      titlePositionConstraint?.constant = (-point)
    }
  }
}

