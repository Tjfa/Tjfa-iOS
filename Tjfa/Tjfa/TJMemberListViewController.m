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

@interface TJMemberListViewController () <UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, strong) NSArray *searchResult;

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

- (void)getDataAtPage:(NSInteger)page
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
            [self.tableView reloadData];
            
            if (users.count < DEFAULT_LIMIT) {
                self.hasMore = NO;
            }
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

- (NSArray *)searchResult
{
    if (_searchResult == nil) {
        _searchResult = [NSArray array];
    }
    return _searchResult;
}

#pragma mark - TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        return self.data.count;
    }
    else {
        return self.searchResult.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TJMemberListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass(TJMemberListCell.class)];
    
    if (tableView == self.tableView) {
        TJUser *user = self.data[indexPath.row];
        [cell setCellWithUser:user];
        if ((indexPath.row == self.data.count - 1) && self.hasMore) {
            self.currentPage = self.currentPage + 1;
            [self getDataAtPage:self.currentPage];
        }
    }
    else {
        TJUser *user = self.searchResult[indexPath.row];
        [cell setCellWithUser:user andSearchKey:self.searchBar.text];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    TJMemberListCell *tjCell = (TJMemberListCell *)cell;
    [tjCell showAnimate];
}

#pragma mark - SearchBar

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [[TJUserManager sharedUserManager] searchForUserWithKey:searchText complete:^(NSArray *users, NSError*error) {
        self.searchResult = users;
        [self.searchDisplayController.searchResultsTableView reloadData];
    }];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[TJMemberListCell class]]) {
        if ([segue.destinationViewController isKindOfClass:[TJMemberCenterTableViewController class]]) {
            TJMemberCenterTableViewController *controller = segue.destinationViewController;
            if (self.searchDisplayController.active) {
                NSIndexPath *indexpath = [self.searchDisplayController.searchResultsTableView indexPathForCell:sender];
                controller.targerUser = self.searchResult[indexpath.row];
            }
            else {
                NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
                
                controller.targerUser = self.data[indexPath.row];
            }
        }
    }
}

@end
