//
//  StrechyParallaxScrollView.m
//  StrechyParallaxScrollView
//
//  Created by Cem Olcay on 12/09/14.
//  Copyright (c) 2014 questa. All rights reserved.
//

#import "StrechyParallaxScrollView.h"

@implementation UIView (FrameStuff)

- (void)setY:(CGFloat)y {
    [self setFrame:CGRectMake(self.frame.origin.x, y, self.frame.size.width, self.frame.size.height)];
}

- (void)setX:(CGFloat)x {
    [self setFrame:CGRectMake(x, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
}

- (void)setWidth:(CGFloat)width {
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height)];
}

- (void)setHeight:(CGFloat)height {
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height)];
}

@end


@interface StrechyParallaxScrollView ()

@property (nonatomic, assign) CGRect defaultTopViewRect;

@end

@implementation StrechyParallaxScrollView

- (instancetype)initWithFrame:(CGRect)frame andTopView:(UIView *)topView {
    self = [super initWithFrame:frame];
    if (self) {
        [self setTopView:topView];
        [self.topView setClipsToBounds:YES];
        [self addSubview:self.topView];
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
        [self.scrollView setDelegate:self];
        [self addSubview:self.scrollView];

        [self setStrechs:YES];
        [self setParallax:YES];
        
        self.parallaxWeight = 0.5f;
        self.defaultTopViewRect = self.topView.frame;
    }
    return self;
}

- (void)addSubview:(UIView *)view {
    if (view == self.scrollView || view == self.topView) {
        [super addSubview:view];
    } else {
        [self.scrollView addSubview:view];
    }
}

- (void)setContentSize:(CGSize)size {
    [self.scrollView setContentSize:size];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y < 0) {
        if (!self.strechs) return;
        
        float diff = -scrollView.contentOffset.y;
        float oldH = self.defaultTopViewRect.size.height;
        float oldW = self.defaultTopViewRect.size.width;
        
        float newH = oldH + diff;
        float newW = oldW*newH/oldH;
        
        [self.topView setFrame:CGRectMake(0, 0, newW, newH)];
        [self.topView setCenter:CGPointMake(self.center.x, self.topView.center.y)];
    }
    
    else {
        if (!self.parallax) return;
        
        float diff = scrollView.contentOffset.y;
        [self.topView setY:-diff * self.parallaxWeight];
    }
}

@end
