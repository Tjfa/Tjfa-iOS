//
//  NetworkClient.m
//  Tjfa
//
//  Created by 邱峰 on 14-3-26.
//  Copyright (c) 2014年 邱峰. All rights reserved.
//

#import "NetworkClient.h"
#import "UIAlertView+NetWorkErrorView.h"

@implementation NetworkClient

//localhost in QiuFeng
//NSString* serverUrlStr = @"http://192.168.113.178/tjfa/";

//word
NSString* serverUrlStr = @"http://sseclass.tongji.edu.cn/tjfa/";

+ (NSURL*)serverUrl
{
    return [NSURL URLWithString:serverUrlStr];
}

+ (NSString*)competitionAddress
{
    return @"competition.php";
}

+ (NSString*)newsAddress
{
    return @"news.php";
}

+ (NSString*)newsContentAddress
{
    return @"newsContent.php";
}

+ (NSString*)matchAdderss
{
    return @"match.php";
}

+ (NSString*)playerAddress
{
    return @"player.php";
}

+ (NSString*)teamAddress
{
    return @"team.php";
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

- (void)searchForAddress:(NSString*)address withParameters:(NSDictionary*)parameters complete:(void (^)(id, NSError*))complete
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    [self POST:address parameters:parameters success:^(NSURLSessionDataTask* task, id responseObject) {
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
                        NSError* error=[[NSError alloc] init];
                        complete(nil, error);
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
}

@end
