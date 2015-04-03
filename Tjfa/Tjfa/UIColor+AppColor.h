//
//  UIColor+AppColor.h
//  Tjfa
//
//  Created by 邱峰 on 6/28/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (AppColor)

/**
 *  app使用统一的背景风格 如果你是 代码添加的view  请使用这个color作为背景
 *
 *  @return backgroud of app color .
 */
+ (UIColor *)appBackgroundColor;

+ (UIColor *)appGrayColor;

/**
 *  输入16进制的颜色  不要输入＃
 *
 *  @param number 0xffffff将返回白色
 *  @param alpha  透明度
 *
 *  @return  number对应的rgb
 */
+ (UIColor *)colorWith16Number:(int)number andAlpha:(float)alpha;

/**
 *  对应默认的alpha＝1 的16进制颜色
 *
 *  @param number 0xffffff将返回白色
 *
 *  @return number对应的rgb
 */
+ (UIColor *)colorWith16Number:(int)number;

/**
 *  dashboard 上 4个字体的颜色
 */
+ (UIColor *)benbuItemColor;
+ (UIColor *)jiadingItemColor;
+ (UIColor *)newsItemColor;
+ (UIColor *)aboutItemColor;
+ (UIColor *)appNavigationBarTintColor;
+ (UIColor *)appRedColor;

@end
