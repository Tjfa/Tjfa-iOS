//
//  NetworkClient.m
//  Tjfa
//
//  Created by 邱峰 on 14-3-26.
//  Copyright (c) 2014年 邱峰. All rights reserved.
//

#import "TJNetworkClient.h"

@implementation TJNetworkClient

//NSString* serverUrlStr = @"http://192.168.113.178/TJFA_SERVER_API/";

//release
NSString *serverUrlStr = @"http://sseclass.tongji.edu.cn/tjfa/";

+ (NSURL *)serverUrl
{
    return [NSURL URLWithString:serverUrlStr];
}

+ (NSString *)competitionAddress
{
    return @"competition.php";
}

+ (NSString *)newsAddress
{
    return @"news.php";
}

+ (NSString *)newsContentAddress
{
    return @"newsContent.php";
}

+ (NSString *)matchAdderss
{
    return @"match.php";
}

+ (NSString *)playerAddress
{
    return @"player.php";
}

+ (NSString *)teamAddress
{
    return @"team.php";
}

+ (TJNetworkClient *)sharedNetworkClient
{
    static TJNetworkClient *_networkClient = nil;
    static dispatch_once_t networkOnceToken;
    dispatch_once(&networkOnceToken, ^{
        NSURLSessionConfiguration* config=[NSURLSessionConfiguration defaultSessionConfiguration];
        _networkClient=[[TJNetworkClient alloc] initWithBaseURL:[TJNetworkClient serverUrl] sessionConfiguration:config];
        _networkClient.responseSerializer=[AFJSONResponseSerializer serializer];
    });
    return _networkClient;
}

- (void)searchForAddress:(NSString *)address withParameters:(NSDictionary *)parameters complete:(void (^)(id, NSError *))complete
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self GET:address parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
            if (httpResponse.statusCode == 200){
                dispatch_async(dispatch_get_main_queue(), ^{
                    complete(responseObject,nil);
                });
            }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSError* error=[[NSError alloc] init];
                        complete(nil, error);
                    });
                }
    }
        failure:^(NSURLSessionDataTask *task, NSError *error) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            dispatch_async(dispatch_get_main_queue(), ^{
                complete(nil, error);
            });
        }];
}

@end
