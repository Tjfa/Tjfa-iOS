//
//  MemberMatchViewController.m
//  Tjfa
//
//  Created by 邱峰 on 3/31/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import "TJMemberMatchViewController.h"
#import "TJMatchManager.h"
#import "MBProgressHUD+AppProgressView.h"
#import "TJMemberMatchCell.h"
#import "TJMatchDayViewController.h"
#import <SVPullToRefresh.h>

@interface TJMemberMatchViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *data;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSDate *fromDate;
@property (nonatomic, strong) NSDate *toDate;
@property (nonatomic, strong) NSDate *nowDate;

@end

const NSTimeInterval weekTimeInterval = 3600 * 24 * 7;

@implementation TJMemberMatchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^(){
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf updateData];
    }];
    [self.tableView triggerPullToRefresh];
}

#pragma mark - Getter & Setter

- (NSArray *)data
{
    if (_data == nil) {
        _data = [NSArray array];
    }
    return _data;
}

- (NSDate *)nowDate
{
    if (_nowDate == nil) {
#if DEBUG
        NSDate *date = [NSDate date];
        _nowDate = [NSDate dateWithTimeInterval:-2 * weekTimeInterval sinceDate:date];
#else
        _nowDate = [NSDate date];

#endif
    }
    return _nowDate;
}

- (NSDate *)fromDate
{
    if (_fromDate == nil) {
        _fromDate = [NSDate dateWithTimeInterval:-weekTimeInterval sinceDate:self.nowDate];
    }
    return _fromDate;
}

- (NSDate *)toDate
{
    if (_toDate == nil) {
        _toDate = [NSDate dateWithTimeInterval:weekTimeInterval sinceDate:self.nowDate];
    }
    return _toDate;
}

#pragma mark - Update Data

- (void)updateData
{
    MBProgressHUD *progress = nil;
    if (self.data.count == 0) {
        progress = [MBProgressHUD progressHUDNetworkLoadingInView:nil withText:@"载入中.."];
    }
    
    [[TJMatchManager sharedMatchManager] getMatchesFrom:self.fromDate to:self.toDate complete:^(NSArray *matches, NSError *error) {
        [self.tableView.pullToRefreshView stopAnimating];
        [progress hide:YES];
        if (error) {
            [MBProgressHUD showErrorProgressInView:nil withText:@"加载失败"];
        }
        else {
            NSLog(@"%lu", (unsigned long)matches.count);
            self.data = matches;
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - TableView DataSource & Delegate

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
    TJMemberMatchCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TJMemberMatchCell class])];
    [cell setCellWithTJMatch:self.data[indexPath.row]];
    
    return cell;
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[TJMatchDayViewController class]]) {
        TJMatchDayViewController *destinationViewController = segue.destinationViewController;
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        destinationViewController.match = self.data[indexPath.row];
    }
}

@end
