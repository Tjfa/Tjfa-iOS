//
//  Welcome3.m
//  Tjfa
//
//  Created by 邱峰 on 7/10/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "Welcome3.h"
#import "UIApplication+MainNav.h"

@implementation Welcome3

+ (Welcome3*)getInstance
{
    NSArray* arr = [[NSBundle mainBundle] loadNibNamed:@"welcome3" owner:nil options:nil];
    return arr[0];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)startToShowDashboard:(UIButton*)sender
{
    if (self.rootView) {
        self.rootView.userInteractionEnabled = NO;
    } else {
        self.userInteractionEnabled = NO;
    }

    /**
     *  animation
     */
    CABasicAnimation* scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];

    [scaleAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    scaleAnimation.duration = 1.0;
    scaleAnimation.toValue = @(2);
    scaleAnimation.delegate = self;
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.removedOnCompletion = NO;
    if (self.rootView) {
        [self.rootView.layer addAnimation:scaleAnimation forKey:nil];
    } else {
        [self.layer addAnimation:scaleAnimation forKey:nil];
    }
}

- (void)animationDidStop:(CAAnimation*)anim finished:(BOOL)flag
{
    if (self.rootView) {
        [self.rootView removeFromSuperview];
    } else {
        [self removeFromSuperview];
    }
    dispatch_time_t delayNanoSeconds = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 0.2);
    dispatch_after(delayNanoSeconds, dispatch_get_main_queue(), ^() {
        [UIApplication showMain];
    });
}

@end
