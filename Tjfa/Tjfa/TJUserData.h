//
//  UserData.h
//  Tjfa
//
//  Created by 邱峰 on 7/10/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJUserData : NSObject

+ (TJUserData *)sharedUserData;

@property (nonatomic) BOOL isFirstLaunch;

@end
