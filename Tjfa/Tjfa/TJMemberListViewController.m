//
//  MemberListViewController.m
//  Tjfa
//
//  Created by 邱峰 on 4/1/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import "TJMemberListViewController.h"
#import "TJModule.h"
#import <SVPullToRefresh.h>
#import "TJMemberListCell.h"
#import "TJSingleChatViewController.h"
#import "TJMemberCenterTableViewController.h"
#import "TJUserManager.h"
#import "TjfaConst.h"
#import "MBProgressHUD+AppProgressView.h"

@interface TJMemberListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL hasMore;

@end

@implementation TJMemberListViewController

- (void)viewDidLoad
{
    __weak typeof(self) weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^() {
        weakSelf.currentPage = 0;
        [weakSelf getDataAtPage:weakSelf.currentPage];
    }];
    [self.tableView triggerPullToRefresh];
}

#pragma mark - Get Data

- (void)getDataAtPage:(int)page
{
    MBProgressHUD *progress = nil;
    if (self.data.count == 0) {
        progress = [MBProgressHUD progressHUDNetworkLoadingInView:nil withText:@"载入中.."];
    }
    
    if (page == 0) {
        self.hasMore = YES;
    }
    
    [[TJUserManager sharedUserManager] getUsersWithLimit:DEFAULT_LIMIT page:page complete:^(NSArray *users, NSError *error) {
        [progress hide:YES];
        
        if (error) {
            [MBProgressHUD showErrorProgressInView:nil withText:@"加载失败"];
        }
        else {
            if (page == 0) {
                [self.tableView.pullToRefreshView stopAnimating];
                self.data = [users mutableCopy];
            }
            else {
                [self.data addObjectsFromArray:users];
            }
            
            if (users.count < DEFAULT_LIMIT) {
                self.hasMore = NO;
            }
            
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - getter & setter

- (NSMutableArray *)data
{
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    return _data;
}

#pragma mark - TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TJMemberListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass(TJMemberListCell.class)];
    TJUser *user = self.data[indexPath.row];
    [cell setCellWithUser:user];

    if ((indexPath.row == self.data.count - 1) && self.hasMore) {
        self.currentPage = self.currentPage + 1;
        [self getDataAtPage:self.currentPage];
    }
    
    return cell;
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[TJMemberListCell class]]) {
        if ([segue.destinationViewController isKindOfClass:[TJMemberCenterTableViewController class]]) {
            NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
            TJMemberCenterTableViewController *controller = segue.destinationViewController;
            controller.targerUser = self.data[indexPath.row];
        }
    }
}

@end
