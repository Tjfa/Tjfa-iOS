//
//  GroupChatViewController.m
//  Tjfa
//
//  Created by 邱峰 on 3/31/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import "TJGroupChatViewController.h"

@implementation TJGroupChatViewController

+ (id)allocWithRouterParams:(NSDictionary *)params
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TJGroupChatViewController *instance = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
    instance.targetEmId = params[@"targetEmId"];
    return instance;
}


@end
