//
//  EaseMobManager.m
//  Tjfa
//
//  Created by 邱峰 on 4/30/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import "EaseMobManager.h"

@implementation EaseMobManager

- (id)sharedEaseMobManager
{
    static dispatch_once_t onceToken;
    static id manager;
    dispatch_once(&onceToken, ^() {
        manager = [[[self class] alloc] init];
    });
    return manager;
}

@end
