//
//  Welcome3.m
//  Tjfa
//
//  Created by 邱峰 on 7/10/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "Welcome3.h"
#import "UIApplication+MainNav.h"
#import "TjfaConst.h"

@interface Welcome3 ()
@property (strong, nonatomic) UIButton* welcomeStart;

@end

@implementation Welcome3

+ (Welcome3*)getInstance
{
    NSArray* arr = [[NSBundle mainBundle] loadNibNamed:@"welcome3" owner:nil options:nil];
    Welcome3* welcome3 = arr[0];
    [welcome3 addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"welcome3"]]];
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    welcome3.frame = CGRectMake(0, 0, screenSize.width, screenSize.height);
    [welcome3 addSubview:welcome3.welcomeStart];
    return welcome3;
}

- (UIButton*)welcomeStart
{
    if (_welcomeStart == nil) {

        _welcomeStart = [[UIButton alloc] initWithFrame:CGRectMake((self.frame.size.width - 95) / 2, self.frame.size.height - 80, 95, 44)];

        [_welcomeStart setImage:[UIImage imageNamed:@"welcomeStart"] forState:UIControlStateNormal];
        [_welcomeStart addTarget:self action:@selector(startToShowDashboard:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _welcomeStart;
}

- (void)startToShowDashboard:(UIButton*)sender
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
    //    if (self.rootView) {
    //        [self.rootView removeFromSuperview];
    //    } else {
    //        [self removeFromSuperview];
    //    }
    dispatch_time_t delayNanoSeconds = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 0.2);
    dispatch_after(delayNanoSeconds, dispatch_get_main_queue(), ^() {
        [UIApplication showMain];
    });
}

@end
