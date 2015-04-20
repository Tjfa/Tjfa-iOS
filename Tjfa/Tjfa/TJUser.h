//
//  TJUser.h
//  Tjfa
//
//  Created by 邱峰 on 3/30/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@class AVFile;

@interface TJUser : AVUser <AVSubclassing>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) AVFile *avatar;

@end
