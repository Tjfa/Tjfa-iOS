//
//  DatabaseManager.h
//  Tjfa
//
//  Created by 邱峰 on 6/25/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJDatabaseManager : NSObject

+ (TJDatabaseManager *)sharedDatabaseManager;

/**
 *  清楚所有的本地数据  在关于页面调用
 */
- (void)clearAllData;

@end
