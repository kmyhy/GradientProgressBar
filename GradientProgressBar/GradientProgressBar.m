//
//  GradientProgressBar.m
//  GradientProgressBar
//
//  Created by qq on 2017/7/3.
//  Copyright © 2017年 qq. All rights reserved.
//

#import "GradientProgressBar.h"


@interface GradientProgressBar(){
    CALayer *backgroundLayer;
    
    CAGradientLayer* gradientLayer;
    
    CALayer* maskLayer;
    
    CALayer* barMaskLayer;
    CATextLayer* textMaskLayer;
    
    CADisplayLink *displayLink;
    
    CGFloat fullAnimationTime;// 从 0-100% 所需的动画时间
    
    CGFloat endValue;
}

@end
@implementation GradientProgressBar

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self setup];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setup];
    }
    return self;
}

-(void)setup{
    
    fullAnimationTime = 4.5;
    _fontSize = 9;
    _leftGap = 10;
    _topGap = 40;
    _barHeight = 6;
    _cornerRadius = 3;
    _percent = 0.5;
    _cgColorArray=[NSArray arrayWithObjects:
                        (id)[[UIColor colorWithRed:0xff/255.0 green:0x63/255.0 blue:0x47/255.0 alpha:1] CGColor],
                        (id)[[UIColor colorWithRed:0x7f/255.0 green:0xff/255.0 blue:0x4f/255.0 alpha:1] CGColor],
                        (id)[[UIColor colorWithRed:0xff/255.0 green:0x63/255.0 blue:0x8b/255.0 alpha:1] CGColor],
                         nil];// 设置渐变颜色数组
    _colorStopArray = @[@0.2, @0.5, @1];// 设置渐变位置数组
    backgroundLayer = [self makeBackgroundLayer];
    [self.layer addSublayer:backgroundLayer];
    
    gradientLayer = [self makeGradientLayer];
    [self.layer addSublayer:gradientLayer];
    
    maskLayer =[self makeMaskLayer];
    
    gradientLayer.mask = maskLayer;

}
-(CALayer*)makeBackgroundLayer{
    
    CGFloat width = CGRectGetWidth(self.frame);
    if(width == 0){
        width = 300;
    }
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(_leftGap,_topGap, width-_leftGap*2, _barHeight);
    
    layer.backgroundColor = [UIColor colorWithRed:0xf5/255.0 green:0xf5/255.0 blue:0xf5/255.0 alpha:1].CGColor;
    layer.masksToBounds = YES;
    layer.cornerRadius = _cornerRadius;
    
    return layer;
}
-(CALayer*)makeMaskLayer{
    CGFloat width = CGRectGetWidth(self.frame);
    if(width == 0){
        width = 300;
    }
    
    CALayer *layer = [CALayer layer];
    layer.frame = gradientLayer.bounds;
//    layer.backgroundColor = [UIColor whiteColor].CGColor;
    
    CALayer *sub1 = [CALayer layer];
    sub1.frame = CGRectMake(_leftGap, _topGap, width-_leftGap*2, _barHeight);
    sub1.backgroundColor = [UIColor whiteColor].CGColor;
    sub1.cornerRadius = _cornerRadius;
    [layer addSublayer:sub1];
    
    barMaskLayer= sub1;
    
    CATextLayer* sub2 = [CATextLayer layer];
    
    sub2.font = (__bridge CFTypeRef _Nullable)([UIFont systemFontOfSize: 9]);
    sub2.fontSize = _fontSize;
    sub2.string = [NSString stringWithFormat:@"%.0f%%",_percent*100];
    
    CGSize size= [self titleTextSize:sub2.string];
    
    sub2.frame = CGRectMake(CGRectGetMaxX(sub1.frame)-size.width/2, _topGap-sub2.fontSize-2, size.width, size.height);
    
    
    sub2.alignmentMode = kCAAlignmentCenter;
    
    sub2.foregroundColor = [UIColor whiteColor].CGColor;
    
    sub2.contentsScale = [UIScreen mainScreen].scale;
    
    textMaskLayer = sub2;
    
    [layer addSublayer:sub2];
    return layer;
}
-(CAGradientLayer*)makeGradientLayer{
    
    CAGradientLayer *layer =  [CAGradientLayer layer];
    layer.frame = CGRectMake(0, 0, self.frame.size.width, CGRectGetMaxY(backgroundLayer.frame));
    layer.masksToBounds = YES;
    layer.cornerRadius = _cornerRadius;
    
    [layer setColors:_cgColorArray];
    
    [layer setLocations:_colorStopArray];
    // 设置渐变开始和结束位置
    [layer setStartPoint:CGPointMake(0, 0)];
    [layer setEndPoint:CGPointMake(1, 0)];
    return layer;
}
-(void)setPercent:(CGFloat)percent{
    
    _percent = percent>1?1:percent;

    CGFloat width = CGRectGetWidth(self.frame);
    if(width == 0){
        width = 300;
    }
    width = width-_leftGap*2;
    NSString* text =[NSString stringWithFormat:@"%.0f%%",_percent*100];
    CGSize size= [self titleTextSize:text];
    textMaskLayer.string =text;
    
    /// 关闭 CALayer 的隐式动画效果！
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    barMaskLayer.frame = CGRectMake(_leftGap, _topGap, width*_percent, _barHeight);
    textMaskLayer.frame = CGRectMake(CGRectGetMaxX(barMaskLayer.frame)-size.width/2, _topGap-_fontSize-2, size.width, size.height);
    [CATransaction commit];
    
    
}
-(void)setPercent:(CGFloat)percent animated:(BOOL)animated{
    if(animated){
        self.percent = percent;
        [self beginAnimate];
    }else{
        self.percent = percent;
    }
}

-(CGSize)titleTextSize:(NSString*) text{
    CGFloat width = CGRectGetWidth(self.frame);
    if(width == 0){
        width = 300;
    }
    NSString* title = text;
    
    NSMutableParagraphStyle* textStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
    textStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary* textFontAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:9], NSParagraphStyleAttributeName: textStyle};
    
    CGSize titleSize = [title boundingRectWithSize: CGSizeMake(width, 9)  options: NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes: textFontAttributes context: nil].size;
    
    return titleSize;
}
-(void)beginAnimate{
    if(_isAnimating == NO){
        // 构造 displaylink 定时器
        displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(timerHandler:)];
        [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
}
// CADisplayLink 定时器处理
-(void)timerHandler:(CADisplayLink *)sender{
    
    if(_isAnimating == NO){// 从 0 开始
        endValue = self.percent;
        _isAnimating = YES;
        self.percent = 0;
    }else{
        CGFloat speed = 1/ fullAnimationTime;
        CGFloat deltaValue = sender.duration * speed;
        if(_percent+deltaValue >=endValue){// 到达终点值，停止动画
            self.percent = endValue;
            [displayLink invalidate];
            _isAnimating = NO;
        }else{
            self.percent = _percent+deltaValue;
        }
//        NSLog(@"delta:%lf percent:%lf width:%lf",deltaValue,self.percent,barMaskLayer.frame.size.width);

    }
    
}

@end
