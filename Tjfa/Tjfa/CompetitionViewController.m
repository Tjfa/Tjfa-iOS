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
#import "RootViewController.h"
#import "UIColor+AppColor.h"
#import "CompetitionCell.h"
#import "TjfaConst.h"
#import <SVPullToRefresh.h>
#import <Routable.h>

@interface CompetitionViewController () <UIGestureRecognizerDelegate,UITableViewDataSource, UITableViewDelegate>
{
    BOOL hasMore;
    __weak Competition* lastCompetition;
}

@property (readwrite, nonatomic) NSNumber* type; // 1-本部 2-嘉定

//section
@property (nonatomic, strong) NSMutableArray* durationList;

//row
@property (nonatomic, strong) NSMutableArray* competitionList;

@property (nonatomic, strong) MBProgressHUD* progressView;

@property (weak, nonatomic) IBOutlet UITableView* tableView;


@end

@implementation CompetitionViewController

+ (id)allocWithRouterParams:(NSDictionary *)params
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CompetitionViewController* instance = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
    instance.type = params[@"type"];
    return instance;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    if ([self.type isEqualToNumber:@1]) {
        self.navigationItem.title = @"本  部";
    } else {
        self.navigationItem.title = @"嘉  定";
    }
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^() {
        [weakSelf getLatestData];
    }];
    
    [self getLocalData];
    hasMore = YES;
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
        if ([self.type isEqualToNumber:@1]) {
            _tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"competitionBgBenBu"]];
        } else {
            _tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"competitionBgJiaDing"]];
        }
    }
}

- (NSMutableArray*)competitionList
{
    if (_competitionList == nil) {
        _competitionList = [[NSMutableArray alloc] init];
    }
    return _competitionList;
}

- (NSMutableArray*)durationList
{
    if (_durationList == nil) {
        _durationList = [[NSMutableArray alloc] init];
    }
    return _durationList;
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

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc] init];
    view.backgroundColor = [UIColor appRedColor];
    return view;
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.sectionHeaderHeight)];
    label.backgroundColor = [UIColor appRedColor];
    label.textColor = [UIColor whiteColor];
    label.text = self.durationList[section];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* competitionTableViewIdentifier = @"CompetitionCell";
    CompetitionCell* cell = [self.tableView dequeueReusableCellWithIdentifier:competitionTableViewIdentifier];
    Competition* competition = self.competitionList[indexPath.section][indexPath.row];
    if (lastCompetition == nil || competition.competitionId < lastCompetition.competitionId) {
        lastCompetition = competition;
    }
    [cell setCellWithCompetition:competition forIndexPath:indexPath];
    if (hasMore && indexPath.section == self.durationList.count - 1 && indexPath.row == [[self.competitionList lastObject] count] - 1) {
        [self getEarlierData];
    }

    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath* indexPath = [self.tableView indexPathForCell:sender];
        
        RootViewController* rootViewController = [segue destinationViewController];
        rootViewController.competition = self.competitionList[indexPath.section][indexPath.row];
    }
}

#pragma mark - getData

- (void)getLocalData
{
    
    NSArray* results = [[CompetitionManager sharedCompetitionManager] getCompetitionsFromCoreDataWithType:self.type];

    if ([results count] == 0) {
        [self.progressView show:YES];
        [self getLatestData];
    } else {
        [self.tableView triggerPullToRefresh];
        [self resetData:results];
    }
}

- (void)getLatestData
{
    lastCompetition = nil;
    __weak typeof(self) weakSelf = self;
    [[CompetitionManager sharedCompetitionManager] getLatestCompetitionsFromNetworkWithType:self.type limit:DEFAULT_LIMIT complete:^(NSArray* results, NSError* error) {
        [weakSelf.progressView removeFromSuperview];
        [weakSelf.tableView.pullToRefreshView stopAnimating];
        if (error) {
            hasMore=NO;
            [MBProgressHUD showWhenNetworkErrorInView:weakSelf.view];
        } else {
            if (results.count < DEFAULT_LIMIT) {
                hasMore=NO;
            } else {
                hasMore=YES;
            }
            
            [weakSelf resetData:results];
        }
    }];
}

- (void)getEarlierData
{
    __weak typeof(self) weakSelf = self;
    [[CompetitionManager sharedCompetitionManager] getEarlierCompetitionsFromNetwork:lastCompetition.competitionId withType:self.type limit:DEFAULT_LIMIT complete:^(NSArray *results, NSError *error) {
        
        if (error) {
            hasMore=NO;
        } else {
            if (results.count < DEFAULT_LIMIT) {
                hasMore=NO;
            }
            for (Competition* competition in results) {
                [weakSelf addCompetitionToCompetitionList:competition];
            }
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void)addCompetitionToCompetitionList:(Competition *)competition
{
    NSUInteger index = [self.durationList indexOfObject:[self convertTimetoString:competition.time]];
    if (index == NSNotFound) {
        [self.durationList addObject:[self convertTimetoString:competition.time]];
        NSMutableArray* arr = [[NSMutableArray alloc] initWithObjects:competition, nil];
        [self.competitionList addObject:arr];
    } else {
        NSMutableArray* arr = self.competitionList[index];
        [arr addObject:competition];
    }
}

- (void)resetData:(NSArray *)data
{
    [self.competitionList removeAllObjects];
    [self.durationList removeAllObjects];
    for (Competition* competition in data) {
        [self addCompetitionToCompetitionList:competition];
    }
    [self.tableView reloadData];
}

- (NSString*)convertTimetoString:(NSString *)time
{
    if (time == nil || [time isEqualToString:@""])
        return nil;

    if ([[time substringFromIndex:[time length] - 1] isEqualToString:@"1"]) {
        return [NSString stringWithFormat:@"%@ 年上学期", [time substringToIndex:[time length] - 1]];
    } else {
        return [NSString stringWithFormat:@"%@ 年下学期", [time substringToIndex:[time length] - 1]];
    }
}

#pragma mark - navigation pop

- (IBAction)backButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
