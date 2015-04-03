//
//  NewsViewController.m
//  Tjfa
//
//  Created by 邱峰 on 7/6/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "TJNewsViewController.h"
#import "TJNewsManager.h"
#import "TJNewsCell.h"
#import "TJNewsContentViewController.h"
#import "MBProgressHUD+AppProgressView.h"
#import <SVPullToRefresh.h>
#import "UIView+RefreshFooterView.h"
#import <CoreData+MagicalRecord.h>
#import "TjfaConst.h"

@interface TJNewsViewController () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) MBProgressHUD *loadProgress;

@end

@implementation TJNewsViewController {
    BOOL hasMore;
}

@synthesize data = _data;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;

    __weak typeof(self) weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^() {
        [weakSelf getLatestNews:nil];
    }];

    if (self.data.count == 0) {
        [self refreshLatestNewsWithProgress:YES];
    }
    else {
        [self.tableView triggerPullToRefresh];
    }
    // Do any additional setup after loading the view.
}

- (void)refreshLatestNewsWithProgress:(BOOL)progress;
{
    if (progress) {
        self.loadProgress = [MBProgressHUD progressHUDNetworkLoadingInView:nil withText:nil];
    }
    [self getLatestNews:self.loadProgress];
}

#pragma mark - getter & setter

- (NSMutableArray *)data
{
    if (_data == nil) {
        _data = [[[TJNewsManager sharedNewsManager] getNewsFromCoreData] mutableCopy];
    }
    return _data;
}

- (void)setData:(NSMutableArray *)data
{
    if (_data != data) {
        _data = data;
        [self.tableView reloadData];
    }
}

- (void)setTableView:(UITableView *)tableView
{
    if (_tableView != tableView) {
        _tableView = tableView;
        _tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"newsBg"]];
        hasMore = YES;
    }
}

#pragma mark - tableview datasource & delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TJNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(TJNewsCell.class)];
    [cell setCellWithNews:self.data[indexPath.row]];
    if (hasMore && indexPath.row == self.data.count - 1) {
        [self getEarlierNews:[self.data lastObject]];
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    News *news = self.data[indexPath.row];
    if ([news.isRead boolValue]) {
        return @"标记未读";
    }
    else {
        return @"标记已读";
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        News *news = self.data[indexPath.row];
        [[TJNewsManager sharedNewsManager] markNewsToggleRead:news];
        [tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - navigation view controller

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UITableViewCell *cell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    TJNewsContentViewController *newsContentViewController = segue.destinationViewController;
    [[TJNewsManager sharedNewsManager] markNewsToRead:self.data[indexPath.row]];
    [self.tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationNone];
    newsContentViewController.news = self.data[indexPath.row];
}

#pragma mark - refresh

- (void)getLatestNews:(MBProgressHUD *)progress
{
    __weak typeof(self) weakSelf = self;
    [[TJNewsManager sharedNewsManager] getLatestNewsFromNetworkWithLimit:DEFAULT_LIMIT complete:^(NSArray *newsArray, NSError *error) {
       
        [weakSelf.tableView.pullToRefreshView stopAnimating];
        
        if (progress) {
            weakSelf.tableView.hidden=NO;
            [weakSelf.loadProgress removeFromSuperview];
            weakSelf.loadProgress=nil;
        }

        if (error) {
            hasMore=NO;
            [MBProgressHUD showWhenNetworkErrorInView:weakSelf.view];
        }
        else {
            if (newsArray.count<DEFAULT_LIMIT) {
                hasMore=NO;
            }
            else {
                hasMore=YES;
            }
            weakSelf.data=[newsArray mutableCopy];
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void)getEarlierNews:(News *)lastNews
{
    if (lastNews == nil) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    [[TJNewsManager sharedNewsManager] getEarlierNewsFromNetworkWithId:lastNews.newsId andLimit:DEFAULT_LIMIT complete:^(NSArray *results, NSError *error) {
        if (error) {
            hasMore=NO;
        } else {
            if (results.count<DEFAULT_LIMIT) hasMore = NO;
            if (!results || results.count == 0) return ;
            
            NSMutableArray* indexPaths = [[NSMutableArray alloc] init];
            for (int i=0; i<results.count; i++) {
                [indexPaths addObject:[NSIndexPath indexPathForRow:weakSelf.data.count inSection:0]];
                [weakSelf.data addObject:results[i]];
            }
            [weakSelf.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
}

#pragma mark - pop navigation

- (IBAction)backButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
