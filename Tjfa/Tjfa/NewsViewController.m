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

@interface NewsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray* data;

@property (nonatomic, weak) IBOutlet UITableView* tableView;

@property (nonatomic, strong) MBProgressHUD* loadProgress;

@end

@implementation NewsViewController
@synthesize data = _data;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self.tableView add]
    // Do any additional setup after loading the view.
}

- (void)refreshLatestNewsWithProgress:(BOOL)progress;
{
    if (progress) {
        [self.loadProgress show:YES];
        self.tableView.hidden = YES;
    }

    __weak NewsViewController* weakSelf = self;
    [[NewsManager sharedNewsManager] getLatestNewsFromNetworkWithLimit:10 complete:^(NSArray* result, NSError* error) {
    
        if (progress){
            weakSelf.tableView.hidden=NO;
            [weakSelf.loadProgress removeFromSuperview];
            weakSelf.loadProgress=nil;
        }
        
        if (error){
            
        }else{
            weakSelf.data=[result mutableCopy];
        }
    }];
}

#pragma mark - getter & setter

- (NSMutableArray*)data
{
    if (_data == nil) {
        _data = [[[NewsManager sharedNewsManager] getNewsFromCoreData] mutableCopy];
        if (_data.count == 0) {
            [self refreshLatestNewsWithProgress:YES];
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
    NewsCell* cell = [tableView dequeueReusableCellWithIdentifier:@"newsCell"];
    [cell setCellWithNews:self.data[indexPath.row]];
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
    newsContentViewController.news = self.data[indexPath.row];
}

@end
