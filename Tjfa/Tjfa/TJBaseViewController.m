//
//  BaseViewController.m
//  Tjfa
//
//  Created by QiuFeng on 3/21/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import "TJBaseViewController.h"

@interface TJBaseViewController ()

@end

@implementation TJBaseViewController

+ (id)allocWithRouterParams:(NSDictionary *)params
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    id instance = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
    return instance;
}

@end
