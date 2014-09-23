//
//  NewsViewController.m
//  Tjfa
//
//  Created by 邱峰 on 7/6/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsManager.h"
#import "NewsCell.h"
#import "NewsContentViewController.h"
#import "MBProgressHUD+AppProgressView.h"
#import "MJRefresh.h"
#import "UIView+RefreshFooterView.h"
#import <CoreData+MagicalRecord.h>
#import "TjfaConst.h"

@interface NewsViewController () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, MJRefreshBaseViewDelegate>

@property (nonatomic, strong) NSMutableArray* data;

@property (nonatomic, weak) IBOutlet UITableView* tableView;

@property (nonatomic, strong) MBProgressHUD* loadProgress;

@property (nonatomic, strong) MJRefreshHeaderView* headerView;

@end

@implementation NewsViewController {
    BOOL hasMore;
}

@synthesize data = _data;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    if (self.data.count == 0) {
        [self refreshLatestNewsWithProgress:YES];
    }
    // Do any additional setup after loading the view.
}

- (void)refreshLatestNewsWithProgress:(BOOL)progress;
{
    if (progress) {
        [self.loadProgress show:YES];
    }
    [self getLatestNews:self.loadProgress];
}

#pragma mark - getter & setter

- (NSMutableArray*)data
{
    if (_data == nil) {
        _data = [[[NewsManager sharedNewsManager] getNewsFromCoreData] mutableCopy];

        for (News* news in _data) {
            NSLog(@"%@", news);
        }
    }
    return _data;
}

- (void)setData:(NSMutableArray*)data
{
    if (_data != data) {
        _data = data;
        [self.tableView reloadData];
    }
}

- (MJRefreshHeaderView*)headerView
{
    if (_headerView == nil) {
        _headerView = [[MJRefreshHeaderView alloc] init];
    }
    return _headerView;
}

- (void)setTableView:(UITableView*)tableView
{
    if (_tableView != tableView) {
        _tableView = tableView;
        self.headerView.scrollView = _tableView;
        self.headerView.delegate = self;
        _tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"newsBg"]];
        hasMore = YES;
    }
}

- (MBProgressHUD*)loadProgress
{
    if (_loadProgress == nil) {
        _loadProgress = [MBProgressHUD progressHUDNetworkLoadingInView:self.view];
        [self.view addSubview:_loadProgress];
    }
    return _loadProgress;
}

#pragma mark - tableview datasource & delegate

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NewsCell* cell = [tableView dequeueReusableCellWithIdentifier:@"NewsCell"];
    [cell setCellWithNews:self.data[indexPath.row]];
    if (hasMore && indexPath.row == self.data.count - 1) {
        [self getEarlierNews:[self.data lastObject]];
    }
    return cell;
}

- (NSString*)tableView:(UITableView*)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath*)indexPath
{
    News* news = self.data[indexPath.row];
    if ([news.isRead boolValue]) {
        return @"标记未读";
    } else {
        return @"标记已读";
    }
}

- (BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath
{
    return YES;
}

- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        News* news = self.data[indexPath.row];
        [[NewsManager sharedNewsManager] markNewsToggleRead:news];
        [tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - navigation view controller

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    UITableViewCell* cell = sender;
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    NewsContentViewController* newsContentViewController = segue.destinationViewController;
    [[NewsManager sharedNewsManager] markNewsToRead:self.data[indexPath.row]];
    [self.tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationNone];
    newsContentViewController.news = self.data[indexPath.row];
}

#pragma mark - refresh

- (void)getLatestNews:(MBProgressHUD*)progress
{
    __weak NewsViewController* weakSelf = self;
    [[NewsManager sharedNewsManager] getLatestNewsFromNetworkWithLimit:DEFAULT_LIMIT complete:^(NSArray* newsArray, NSError* error) {
        [weakSelf.headerView endRefreshing];
        
        if (progress){
            weakSelf.tableView.hidden=NO;
            [weakSelf.loadProgress removeFromSuperview];
            weakSelf.loadProgress=nil;
        }

        if (error){
            hasMore=NO;
            [MBProgressHUD showWhenNetworkErrorInView:weakSelf.view];
        }
        else{
            if (newsArray.count<DEFAULT_LIMIT) hasMore=NO;
            else hasMore=YES;
            weakSelf.data=[newsArray mutableCopy];
            [weakSelf.tableView reloadData];
            [weakSelf.headerView endRefreshing];
        }
    }];
}

- (void)getEarlierNews:(News*)lastNews
{
    if (lastNews == nil)
        return;
    __weak NewsViewController* weakSelf = self;
    [[NewsManager sharedNewsManager] getEarlierNewsFromNetworkWithId:lastNews.newsId andLimit:DEFAULT_LIMIT complete:^(NSArray* results, NSError* error) {
        if (error){
            hasMore=NO;
        }else{
            if (results.count<DEFAULT_LIMIT) hasMore=NO;
            if (!results || results.count==0) return ;
            
            NSMutableArray* indexPaths=[[NSMutableArray alloc] init];
            for (int i=0; i<results.count; i++){
                [indexPaths addObject:[NSIndexPath indexPathForRow:weakSelf.data.count inSection:0]];
                [weakSelf.data addObject:results[i]];
            }
            [weakSelf.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
}

#pragma mark - MJRefresh delegate

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView*)refreshView
{
    if (refreshView == self.headerView) {
        [self getLatestNews:nil];
    }
}

#pragma mark - pop navigation

- (IBAction)backButtonClick:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)dealloc
{
    [self.headerView free];
}

@end
