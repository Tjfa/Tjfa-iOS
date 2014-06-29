//
//  DashboardButton.m
//  Tjfa
//
//  Created by 邱峰 on 6/28/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "DashboardButton.h"

@interface DashboardButton ()

@end

@implementation DashboardButton

- (instancetype)initWithFrame:(CGRect)frame andImage:(UIImage*)image andTarget:(id)target action:(SEL)action
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor appGrayColor];
        [self setImage:image forState:UIControlStateNormal];
        self.exclusiveTouch=YES;
        [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

@end
