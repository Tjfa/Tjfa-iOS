//
//  UIView+RefreshFooterView.m
//  Tjfa
//
//  Created by 邱峰 on 7/9/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "UIView+RefreshFooterView.h"
#import "UIColor+AppColor.h"

@implementation UIView (RefreshFooterView)

+ (UIView*)loadMoreFooterView
{
    CGRect footerRect = CGRectMake(0, 0, 320, 40);
    return [self loadMoreFooterViewWithFrame:footerRect];
}

+ (UIView*)noMoreFotterView
{
    CGRect footerRect = CGRectMake(0, 0, 320, 40);
    return [self noMoreFotterViewWithFrame:footerRect];
}

+ (UIView*)loadMoreFooterViewWithFrame:(CGRect)frame
{
    UIActivityIndicatorView* activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityIndicatorView startAnimating];
    activityIndicatorView.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
    UIView* loadMoreFooterView = [[UIView alloc] initWithFrame:frame];
    loadMoreFooterView.backgroundColor=[UIColor appBackgroundColor];
    [loadMoreFooterView addSubview:activityIndicatorView];
    return loadMoreFooterView;
}

+ (UIView*)noMoreFotterViewWithFrame:(CGRect)frame
{
    UIView* loadMoreFooterView = [[UIView alloc] initWithFrame:frame];
    loadMoreFooterView.backgroundColor=[UIColor appBackgroundColor];
    UILabel* label = [[UILabel alloc] initWithFrame:frame];
    label.text = @"没有更多了";
    [loadMoreFooterView addSubview:label];
    return loadMoreFooterView;
}

@end
