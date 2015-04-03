//
//  Welcome2.m
//  Tjfa
//
//  Created by 邱峰 on 8/3/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "TJWelcome2.h"

@implementation TJWelcome2

+ (TJWelcome2 *)getInstance
{
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:nil options:nil];
    TJWelcome2 *welcome2 = arr[0];
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
    [bg setImage:[UIImage imageNamed:@"welcome2"]];
    [welcome2 addSubview:bg];
    return welcome2;
}

@end
