//
//  CompetitionViewController.m
//  Tjfa
//
//  Created by JackYu on 6/29/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "CompetitionViewController.h"
#import "CompetitionManager.h"
#import "UIView+RefreshFooterView.h"
#import "MBProgressHUD+AppProgressView.h"
#import "UIViewController+Identifier.h"
#import "RootViewController.h"
#import "UIColor+AppColor.h"
#import "CompetitionCell.h"

@interface CompetitionViewController () {
    MJRefreshHeaderView* header;
    BOOL hasMore;
}
@property (nonatomic, strong) NSMutableArray* durationList;
@property (nonatomic, strong) NSMutableArray* competitionList;

@property (nonatomic, strong) MBProgressHUD* progressView;

@end

@implementation CompetitionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    if ([self.campusType intValue] == 1) {
        self.navigationItem.title = @"本  部";
    } else {
        self.navigationItem.title = @"嘉  定";
    }

    hasMore = YES;
    self.competitionList = [[NSMutableArray alloc] init];
    self.durationList = [[NSMutableArray alloc] init];

    // 注册上拉下拉刷新控件

    [self getLocalData];
}

#pragma mark - getter & setter

- (MBProgressHUD*)progressView
{
    if (_progressView == nil) {
        _progressView = [MBProgressHUD progressHUDNetworkLoadingInView:self.view];
        [self.view addSubview:_progressView];
    }
    return _progressView;
}

- (void)setTableView:(UITableView*)tableView
{
    if (_tableView != tableView) {
        _tableView = tableView;
        _tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"competitionBg"]];
        header = [[MJRefreshHeaderView alloc] init];
        header.delegate = self;
        header.scrollView = _tableView;
    }
}

#pragma mark - tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return self.durationList.count;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.competitionList[section] count];
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.sectionHeaderHeight)];
    label.backgroundColor = [UIColor appTableViewSectionColor];
    label.textColor = [UIColor whiteColor];
    label.text = self.durationList[section];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* competitionTableViewIdentifier = @"CompetitionCell";
    CompetitionCell* cell = [self.tableView dequeueReusableCellWithIdentifier:competitionTableViewIdentifier];
    [cell setCellWithCompetition:self.competitionList[indexPath.section][indexPath.row] forIndexPath:indexPath];
    if (hasMore && indexPath.section == self.durationList.count - 1 && indexPath.row == [[self.competitionList lastObject] count] - 1) {
        [self pullupGetMore];
    }

    return cell;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath* indexPath = [self.tableView indexPathForCell:sender];

        RootViewController* rootViewController = [segue destinationViewController];
        rootViewController.competition = self.competitionList[indexPath.section][indexPath.row];
    }
}

// 获取数据
// drop-down refresh --- get latest data from server
- (void)dropdownRefresh
{
    [[CompetitionManager sharedCompetitionManager] getLatestCompetitionsFromNetworkWithType:self.campusType limit:10 complete:^(NSArray* results, NSError* error) {
        [self.progressView removeFromSuperview];
        if (error) {
            hasMore=NO;
        } else {
            [self handleCompetitionDataList:results resetSign:YES];
        }
        [header endRefreshing];
    }];
}

// get local data --- when first enter this page
- (void)getLocalData
{
    NSArray* results = [[CompetitionManager sharedCompetitionManager] getCompetitionsFromCoreDataWithType:self.campusType];

    if ([results count] == 0) {
        [self.progressView show:YES];
        [self dropdownRefresh];
    } else {
        [self handleCompetitionDataList:results resetSign:YES];
    }
}

// pull-up get more --- get earlier server data
- (void)pullupGetMore
{
    Competition* lastCompetition = [[[CompetitionManager sharedCompetitionManager] getCompetitionsFromCoreDataWithType:self.campusType] lastObject];

    if (lastCompetition == nil) {
        hasMore = NO;
    } else {
        [[CompetitionManager sharedCompetitionManager] getEarlierCompetitionsFromNetwork:[lastCompetition competitionId] withType:@(1) limit:10 complete:^(NSArray* results, NSError* error) {
            
            if (error) {
                hasMore=NO;
                NSLog(@"%@",error);
            } else {
                if (results.count == 0) {
                    hasMore = YES;
                } else {
                    [self handleCompetitionDataList:results resetSign:false];
                }
            }
            [header endRefreshing];
        }];
    }
}

- (void)handleCompetitionDataList:(NSArray*)dataList resetSign:(BOOL)sign
{
    BOOL firstGroupSign = YES;
    NSString* tempCompetitionDuration;
    NSMutableArray* tempComptitionArray = [[NSMutableArray alloc] init];

    if (sign) {
        hasMore = YES;
        [self.competitionList removeAllObjects];
        [self.durationList removeAllObjects];
    }

    for (Competition* competition in dataList) {
        if (![tempCompetitionDuration isEqualToString:[competition time]]) {
            if (firstGroupSign) {
                firstGroupSign = NO;
            } else {
                [self.competitionList addObject:tempComptitionArray];
                [self.durationList addObject:[self convertTimetoString:tempCompetitionDuration]];
            }
            tempCompetitionDuration = [competition time];
            tempComptitionArray = [[NSMutableArray alloc] init];
        }
        [tempComptitionArray addObject:competition];
    }

    [self.competitionList addObject:tempComptitionArray];
    [self.durationList addObject:[self convertTimetoString:tempCompetitionDuration]];

    [self.tableView reloadData];
}

- (NSString*)convertTimetoString:(NSString*)time
{
    if ([[time substringFromIndex:[time length] - 1] isEqualToString:@"1"]) {
        return [NSString stringWithFormat:@"%@ 年上学期", [time substringToIndex:[time length] - 1]];
    } else {
        return [NSString stringWithFormat:@"%@ 年下学期", [time substringToIndex:[time length] - 1]];
    }
}

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView*)refreshView
{
    [self dropdownRefresh];
}

#pragma mark-- navigation pop

- (IBAction)backButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    [header free];
}

@end
