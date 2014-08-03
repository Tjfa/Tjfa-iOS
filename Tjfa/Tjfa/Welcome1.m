//
//  Welcome1.m
//  Tjfa
//
//  Created by 邱峰 on 8/3/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "Welcome1.h"

@implementation Welcome1

+ (Welcome1*)getInstance
{
    NSArray* arr = [[NSBundle mainBundle] loadNibNamed:@"welcome1" owner:nil options:nil];
    Welcome1* welcome1 = arr[0];
    [welcome1 addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"welcome1"]]];
    return welcome1;
}

@end
