//
//  UIAlertView+NetWorkErrorView.m
//  Tjfa
//
//  Created by 邱峰 on 7/8/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "UIAlertView+NetWorkErrorView.h"

@implementation UIAlertView (NetWorkErrorView)

+ (UIAlertView*)alertViewWithErrorNetWork
{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"网络异常" message:@"检查网络是否异常,如果一切正常，你可以到关于界面中的问题与反馈及时给出您的意见" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    return alertView;
}

@end
