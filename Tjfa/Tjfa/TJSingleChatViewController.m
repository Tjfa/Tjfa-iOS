//
//  SingleChatViewController.m
//  Tjfa
//
//  Created by 邱峰 on 3/31/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import "TJSingleChatViewController.h"
#import "TJModule.h"
#import "TJUserManager.h"

@implementation TJSingleChatViewController

@synthesize targetUser = _targetUser;
@synthesize targetEmId = _targetEmId;

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

- (void)setTargetEmId:(NSString *)targetEmId
{
    if (_targetEmId != targetEmId) {
        _targetEmId = targetEmId;
        [self targetUser];
    }
}

- (TJUser *)targetUser
{
    if (_targetUser == nil) {
        [[TJUserManager sharedUserManager] findUserWithAccount:self.targetEmId complete:^(TJUser *user, NSError *error) {
            if (error) {
                
            }
            else {
                _targetUser = user;
                self.title = [NSString stringWithFormat:@"与 %@ 聊天中", user.name];
            }
        }];
    }
    return _targetUser;
}

#pragma mark - Override 
- (TJUser *)getTargetUserBySenderId:(NSString *)senderId
{
    return self.targetUser;
}

@end
