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

- (NSURLSessionDataTask*)searchForAddress:(NSString*)address withParameters:(NSDictionary*)parametersArray complete:(void (^)(NSArray* results, NSError* error))complete;

@end
