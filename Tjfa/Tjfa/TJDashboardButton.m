//
//  DashboardButton.m
//  Tjfa
//
//  Created by 邱峰 on 6/28/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "TJDashboardButton.h"

@interface TJDashboardButton ()

@end

@implementation TJDashboardButton

- (instancetype)initWithFrame:(CGRect)frame andImage:(UIImage*)image andTarget:(id)target action:(SEL)action
{
    if (self = [super initWithFrame:frame]) {
        [self setImage:image forState:UIControlStateNormal];
        self.exclusiveTouch=YES;
        [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

@end
