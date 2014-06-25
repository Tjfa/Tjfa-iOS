//
//  NetworkClient.m
//  Tjfa
//
//  Created by 邱峰 on 14-3-26.
//  Copyright (c) 2014年 邱峰. All rights reserved.
//

#import "NetworkClient.h"

@implementation NetworkClient

NSString* serverUrlStr = @"http://10.0.1.35/TacWebsite2";

+ (NSURL*)serverUrl
{
    return [NSURL URLWithString:serverUrlStr];
}

+ (NetworkClient*)sharedNetworkClient
{
    static NetworkClient* _networkClient = nil;
    static dispatch_once_t networkOnceToken;
    dispatch_once(&networkOnceToken, ^{
        NSURLSessionConfiguration* config=[NSURLSessionConfiguration defaultSessionConfiguration];
        _networkClient=[[NetworkClient alloc] initWithBaseURL:[NetworkClient serverUrl] sessionConfiguration:config];
        _networkClient.responseSerializer=[AFJSONResponseSerializer serializer];
    });
    return _networkClient;
}

- (NSURLSessionDataTask*)searchForAddress:(NSString*)address withParameters:(NSDictionary*)parameters complete:(void (^)(NSArray*, NSError*))complete
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    NSURLSessionDataTask* task = [self POST:address parameters:parameters success:^(NSURLSessionDataTask* task, id responseObject) {
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            NSLog(@"successful");
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
            if (httpResponse.statusCode == 200)     //200是成功返回
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"%@",responseObject);
                    complete(responseObject,nil);
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    complete(nil, nil);
                });
            }
    }
        failure:^(NSURLSessionDataTask* task, NSError* error) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            NSLog(@"fail");
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"%@",error);
                complete(nil, error);
            });
        }];
    return task;
}

@end
