//
//  NetworkClient.h
//  Tjfa
//
//  Created by 邱峰 on 14-3-26.
//  Copyright (c) 2014年 邱峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"

@interface NetworkClient : AFHTTPSessionManager

+ (NetworkClient*)sharedNetworkClient;

+ (NSString*)competitionAddress;

+ (NSString*)newsAddress;

+ (NSString*)newsContentAddress;

+ (NSString*)matchAdderss;

/**
 *  complete block will call on main thread
 */
- (NSURLSessionDataTask*)searchForAddress:(NSString*)address withParameters:(NSDictionary*)parameters complete:(void (^)(id results, NSError* error))complete;

//- (void)getContentNewsWithParameters:(NSDictionary*)parameters complete:(void (^)(id results, NSError* error))complete;

@end
