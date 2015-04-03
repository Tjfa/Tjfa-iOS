//
//  Developer.m
//  Tjfa
//
//  Created by 邱峰 on 6/28/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "TJDeveloper.h"

@implementation TJDeveloper

- (instancetype)initWithName:(NSString*)name imageName:(NSString*)imageName
{
    if (self = [super init]) {
        self.name = name;
        self.image = [UIImage imageNamed:imageName];
    }
    return self;
}

@end
