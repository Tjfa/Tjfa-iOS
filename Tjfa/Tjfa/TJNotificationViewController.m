//
//  TJNotificationViewController.m
//  Tjfa
//
//  Created by 邱峰 on 4/16/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import "TJNotificationViewController.h"
#import "TJLocalPushNotificationManager.h"
#import <SVPullToRefresh.h>
#import "TJMatchManager.h"
#import "TJUser.h"
#import "TJMessage.h"
#import "TJChatNotificationCell.h"
#import <EaseMob.h>
#import <Routable.h>

@interface TJNotificationViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *data;

@end

@implementation TJNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^(){
        [weakSelf reloadAllData];
    }];
    [self.tableView triggerPullToRefresh];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data

- (NSMutableArray *)data
{
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    return _data;
}

#pragma mark - Reload Data

- (void)updateData:(NSMutableArray *)data
{
    dispatch_async(dispatch_get_main_queue(), ^() {
        if (data != nil) {
            [self.data removeAllObjects];
            for (EMConversation *conversation in data) {
                if (conversation.latestMessageFromOthers != nil) {
                    [self.data addObject:conversation];
                }
            }
        }
        
        [self.tableView.pullToRefreshView stopAnimating];
        [self.tableView reloadData];
    });
}

- (void)reloadAllData
{
    dispatch_async(dispatch_queue_create("Notification Load Data", nil), ^(){
        
        BOOL isLogin = [[EaseMob sharedInstance].chatManager isLoggedIn];

        TJUser *user = [TJUser currentUser];
        
        NSDictionary *loginInfo =  [[EaseMob sharedInstance].chatManager loginInfo];
        if (![loginInfo[@"username"] isEqualToString:user.username]) {
            isLogin = NO;
            [[EaseMob sharedInstance].chatManager logoffWithUnbindDeviceToken:YES error:nil];
        }
            
        if (isLogin) {
            [self updateData:[[[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:YES] mutableCopy]];
        }
        else {
            [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:user.username password:user.username completion:^(NSDictionary *info, EMError *error) {
                if (error) {
                    [self updateData:nil];
                }
                else {
                    [self updateData:[[[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:YES] mutableCopy]];
                }
            }onQueue:nil];
        }
    });
}

#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    EMConversation *conversation = self.data[indexPath.row];

    [self.tableView beginUpdates];
    [[EaseMob sharedInstance].chatManager removeConversationByChatter:conversation.chatter deleteMessages:NO append2Chat:YES];
    [self.data removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    [self.tableView endUpdates];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EMConversation *conversation = self.data[indexPath.row];
    EMMessage *lastMessage = conversation.latestMessageFromOthers;
    
    TJChatNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TJChatNotificationCell class])];
    [cell setCellWithEMMessage:lastMessage];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EMConversation *conversation = self.data[indexPath.row];
    EMMessage *lastMessage = conversation.latestMessageFromOthers;

    [[Routable sharedRouter] open:@"singleChat" withParams:@{@"targetEmId" : lastMessage.from}];
}

@end
