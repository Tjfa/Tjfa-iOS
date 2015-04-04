//
//  TJAccessoryView.m
//  Tjfa
//
//  Created by 邱峰 on 4/4/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import "TJAccessoryView.h"

@implementation TJAccessoryView

- (instancetype)init
{
    NSAssert(NO, @"I come from NIB, So, Use getAccessoryView!");
    return nil;
}

- (TJAccessoryView *)getAccessoryView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

@end
