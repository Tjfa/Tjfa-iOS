//
//  MJRefreshHeaderView.m
//  MJRefresh
//
//  Created by mj on 13-2-26.
//  Copyright (c) 2013年 itcast. All rights reserved.
//  下拉刷新

#import "MJRefreshConst.h"
#import "MJRefreshHeaderView.h"

@interface MJRefreshHeaderView ()

@end

@implementation MJRefreshHeaderView

+ (instancetype)header
{
    return [[MJRefreshHeaderView alloc] init];
}

#pragma mark - UIScrollView相关
#pragma mark 重写设置ScrollView
- (void)setScrollView:(UIScrollView*)scrollView
{
    [super setScrollView:scrollView];

    // 1.设置边框
    self.frame = CGRectMake(0, -MJRefreshViewHeight, scrollView.frame.size.width, MJRefreshViewHeight);
}

#pragma mark 设置状态
- (void)setState:(MJRefreshState)state
{
    // 1.一样的就直接返回
    if (_state == state)
        return;

    // 2.保存旧状态
    MJRefreshState oldState = _state;

    // 3.调用父类方法
    [super setState:state];

    // 4.根据状态执行不同的操作
    switch (state) {
    case MJRefreshStatePulling: // 松开可立即刷新
    {
        // 设置文字
        // _statusLabel.text = MJRefreshHeaderReleaseToRefresh;
        // 执行动画
        [UIView animateWithDuration:MJRefreshAnimationDuration animations:^{
               // _arrowImage.transform = CGAffineTransformMakeRotation(M_PI);
                UIEdgeInsets inset = _scrollView.contentInset;
                inset.top = _scrollViewInitInset.top;
                _scrollView.contentInset = inset;
        }];
        break;
    }

    case MJRefreshStateNormal: // 下拉可以刷新
    {
        // 设置文字
        //_statusLabel.text = MJRefreshHeaderPullToRefresh;
        // 执行动画
        [UIView animateWithDuration:MJRefreshAnimationDuration animations:^{
                //_arrowImage.transform = CGAffineTransformIdentity;
          
                UIEdgeInsets inset = _scrollView.contentInset;
                inset.top = _scrollViewInitInset.top;
                _scrollView.contentInset = inset;
        }];

        // 刷新完毕
        if (MJRefreshStateRefreshing == oldState) {
        }
        break;
    }

    case MJRefreshStateRefreshing: // 正在刷新中
    {
        // 设置文字
        //_statusLabel.text = MJRefreshHeaderRefreshing;
        // 执行动画
        [UIView animateWithDuration:MJRefreshAnimationDuration animations:^{
               // _arrowImage.transform = CGAffineTransformIdentity;
                // 1.增加65的滚动区域
                UIEdgeInsets inset = _scrollView.contentInset;
                inset.top = _scrollViewInitInset.top + MJRefreshViewHeight;
                _scrollView.contentInset = inset;
                // 2.设置滚动位置
                _scrollView.contentOffset = CGPointMake(0, - _scrollViewInitInset.top - MJRefreshViewHeight);
        }];
        break;
    }

    default:
        break;
    }
}

#pragma mark - 在父类中用得上
// 合理的Y值(刚好看到下拉刷新控件时的contentOffset.y，取相反数)
- (CGFloat)validY
{
    return _scrollViewInitInset.top;
}

// view的类型
- (int)viewType
{
    return MJRefreshViewTypeHeader;
}
@end