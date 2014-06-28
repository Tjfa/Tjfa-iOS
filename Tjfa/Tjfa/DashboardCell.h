//
//  DashboardButtonView.h
//  Tjfa
//
//  Created by 邱峰 on 6/28/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DashboardButton.h"

@interface DashboardCell : UIView

typedef NS_ENUM(NSInteger, DashboardLabelDirection) {
    kLeft = 0,
    kRight = 1,
};

@property (nonatomic, strong) DashboardButton* dashboardButton;

@property (nonatomic, strong) UILabel* nameLable;

/**
 *  DashboardView init
 *  dashboardView 由两部分组成  一部分是 按钮 另外一个部分是lable
 *
 *  @param frame     设置 dashboardView 的frame
 *  @param image     按钮的image
 *  @param lable     lable上面显示的字
 *  @param direction kLeft 或者 kRight 表示 lable在左边还是右边
 *  @param target    button 点击后的target
 *  @param action    button 点击后的action
 *  @param size      button的size  button将是圆形
 *
 */
- (instancetype)initWithFrame:(CGRect)frame image:(UIImage*)image labelName:(NSString*)label direction:(DashboardLabelDirection)direction target:(id)target action:(SEL)action dashboardSize:(CGFloat)size;

- (void)showWithAnimateComplete:(void (^)(BOOL finished))complete;

- (void)showWithAnimateAfterDelay:(NSTimeInterval)delay complete:(void (^)(BOOL finished))complete;

- (void)hideWithAnimateComplete:(void (^)(BOOL finished))complete;

- (void)hideWithAnimateAfterDelay:(NSTimeInterval)delay complete:(void (^)(BOOL finished))complete;

@end
