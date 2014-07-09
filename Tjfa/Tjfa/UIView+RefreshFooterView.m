//
//  UIView+RefreshFooterView.m
//  Tjfa
//
//  Created by 邱峰 on 7/9/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "UIView+RefreshFooterView.h"

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
    UIActivityIndicatorView* activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    UIView* loadMoreFooterView = [[UIView alloc] initWithFrame:frame];
    [loadMoreFooterView addSubview:activityIndicatorView];
    return loadMoreFooterView;
}

+ (UIView*)noMoreFotterViewWithFrame:(CGRect)frame
{
    UIView* loadMoreFooterView = [[UIView alloc] initWithFrame:frame];
    UILabel* label = [[UILabel alloc] initWithFrame:frame];
    label.text = @"没有更多了";
    [loadMoreFooterView addSubview:label];
    return loadMoreFooterView;
}

@end
