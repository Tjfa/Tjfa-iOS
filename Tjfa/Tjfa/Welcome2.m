//
//  Welcome2.m
//  Tjfa
//
//  Created by 邱峰 on 8/3/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "Welcome2.h"

@implementation Welcome2

+ (Welcome2*)getInstance
{
    NSArray* arr = [[NSBundle mainBundle] loadNibNamed:@"welcome2" owner:nil options:nil];
    Welcome2* welcome2 = arr[0];
    [welcome2 addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"welcome2"]]];
    return welcome2;
}

@end
