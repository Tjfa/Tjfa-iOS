//
//  UIView+RefreshFooterView.h
//  Tjfa
//
//  Created by 邱峰 on 7/9/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (RefreshFooterView)

+ (UIView*)loadMoreFooterView;

+ (UIView*)noMoreFotterView;

+ (UIView*)loadMoreFooterViewWithFrame:(CGRect)frame;

+ (UIView*)noMoreFotterViewWithFrame:(CGRect)frame;

@end
