//
//  EaseMobManager.h
//  Tjfa
//
//  Created by 邱峰 on 4/30/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EaseMobManager : NSObject

- (id)sharedEaseMobManager;

- (NSInteger)getAllUnreadMessageCount;


@end
