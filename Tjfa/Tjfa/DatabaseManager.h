//
//  DatabaseManager.h
//  Tjfa
//
//  Created by 邱峰 on 6/25/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DatabaseManager : NSObject

+ (DatabaseManager*)sharedDatabaseManager;

- (void)clearAllData;

@end
