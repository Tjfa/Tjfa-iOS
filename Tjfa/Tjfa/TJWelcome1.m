//
//  Welcome1.m
//  Tjfa
//
//  Created by 邱峰 on 8/3/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "TJWelcome1.h"

@implementation TJWelcome1

+ (TJWelcome1 *)getInstance
{
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"welcome1" owner:nil options:nil];
    TJWelcome1 *welcome1 = arr[0];

    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
    [bg setImage:[UIImage imageNamed:@"welcome1"]];
    [welcome1 addSubview:bg];
    return welcome1;
}

@end
