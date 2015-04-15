//
//  SingleChatViewController.m
//  Tjfa
//
//  Created by 邱峰 on 3/31/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import "TJSingleChatViewController.h"
#import "TJModule.h"

@implementation TJSingleChatViewController

+ (id)allocWithRouterParams:(NSDictionary *)params
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TJSingleChatViewController *instance = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
    instance.targetEmId = params[@"targetEmId"];
    return instance;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)setTargetUser:(TJUser *)targetUser
{
    if (_targetUser != targetUser) {
        _targetUser = targetUser;
        self.targetEmId = targetUser.username;
        self.isGroup = NO;
    }
}

@end
