//
//  UIColor+AppColor.m
//  Tjfa
//
//  Created by 邱峰 on 6/28/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "UIColor+AppColor.h"

@implementation UIColor (AppColor)

+ (UIColor*)colorWith16Number:(int)number andAlpha:(float)alpha
{
    int ff = (1 << 8) - 1;
    int r = (number >> 16) & ff;
    int g = (number >> 8) & ff;
    int b = number & ff;
    return [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:alpha];
}

+ (UIColor*)colorWith16Number:(int)number
{
    return [UIColor colorWith16Number:number andAlpha:1.0];
}

+ (UIColor*)appBackgroundColor
{
    return [UIColor colorWith16Number:0xF8F8F8];
}

+ (UIColor*)appGrayColor
{
    return [UIColor colorWith16Number:0xebebeb];
}

+ (UIColor*)benbuItemColor
{
    return [UIColor colorWith16Number:0x06ac8f];
}

+ (UIColor*)jiadingItemColor
{
    return [UIColor colorWith16Number:0xcf9335];
}

+ (UIColor*)newsItemColor
{
    return [UIColor colorWith16Number:0x23367f];
}

+ (UIColor*)aboutItemColor
{
    return [UIColor colorWith16Number:0xb8125c];
}

+ (UIColor*)appNavigationBarTintColor
{
    return [UIColor colorWith16Number:0x910100];
}

+ (UIColor*)appRedColor
{
    return [UIColor colorWith16Number:0x910100];
}

@end
