//
//  StrechyParallaxScrollView.h
//  StrechyParallaxScrollView
//
//  Created by Cem Olcay on 12/09/14.
//  Copyright (c) 2014 questa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StrechyParallaxScrollView : UIView <UIScrollViewDelegate>

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIScrollView *scrollView;

- (instancetype)initWithFrame:(CGRect)frame andTopView:(UIView *)topView;

- (void)addSubview:(UIView *)view;
- (void)setContentSize:(CGSize)size;

//weigth for parallax speed
//1 equals to scroll view speed, so i recommend something between 0 and 1
//default 0.5f
@property (nonatomic, assign) CGFloat parallaxWeight;

//optional bool for turning off streching feature
//default YES
@property (nonatomic, assign, getter = isStrechs) BOOL strechs;

//optional bool for turning off parallax feature
//default YES
@property (nonatomic, assign, getter = isParallax) BOOL parallax;

@end
