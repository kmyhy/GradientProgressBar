//
//  GradientProgressBar.h
//  GradientProgressBar
//
//  Created by qq on 2017/7/3.
//  Copyright © 2017年 qq. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface GradientProgressBar : UIView

@property(assign,nonatomic)CGFloat cornerRadius;
@property(copy,nonatomic)NSArray* cgColorArray;

@property(copy,nonatomic)NSArray* colorStopArray;
@property(assign,nonatomic)CGFloat percent;
@property(assign,nonatomic)CGFloat topGap;
@property(assign,nonatomic)CGFloat leftGap;
@property(assign,nonatomic)CGFloat barHeight;
@property(assign,nonatomic)CGFloat fontSize;
@property(assign,nonatomic,readonly)BOOL isAnimating;

-(void)beginAnimate;
-(void)setPercent:(CGFloat)percent animated:(BOOL)animated;
@end
