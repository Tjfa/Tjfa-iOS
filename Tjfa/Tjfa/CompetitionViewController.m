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
#import "MatchViewController.h"

@interface CompetitionViewController () {
    MJRefreshHeaderView* header;
    //    MJRefreshFooterView *footer;
    BOOL hasMore;

    UIView* loadMoreFooterView;
    UIView* noMoreFooterView;
}
@property (nonatomic, strong) NSMutableArray* durationList;
@property (nonatomic, strong) NSMutableArray* competitionList;

@property (nonatomic, strong) MBProgressHUD* progressView;

@end

@implementation CompetitionViewController

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (self.campusType == 1) {
        self.navigationItem.title = @"本部赛事";
    } else {
        self.navigationItem.title = @"嘉定赛事";
    }

    hasMore = true;

    //    NSMutableArray *firstArray = [[NSMutableArray alloc] initWithArray:@[@"first",@"second",@"third"]];
    //    NSMutableArray *secondAray = [[NSMutableArray alloc]initWithArray:@[@"test1",@"test2",@"test3"]];
    self.competitionList = [[NSMutableArray alloc] init];
    self.durationList = [[NSMutableArray alloc] init];
    //[self.durationList addObject:@"2014年第二学期"];
    //[self.competitionList addObject:firstArray];
    //[self.durationList addObject:@"2014年第一学期"];
    //[self.competitionList addObject:secondAray];

    // 注册上拉下拉刷新控件
    header = [[MJRefreshHeaderView alloc] init];
    header.delegate = self;
    header.scrollView = self.tableView;

    //    footer = [[MJRefreshFooterView alloc] init];
    //    footer.delegate = self;
    //    footer.scrollView = self.tableView;

    // initial has more table footer view
    //    CGRect footerRect = CGRectMake(0, 0, 320, 40);
    //    UILabel* tableFooter = [[UILabel alloc] initWithFrame:footerRect];
    //    tableFooter.textColor = [UIColor whiteColor];
    //    tableFooter.backgroundColor = [UIColor lightTextColor];
    //    tableFooter.opaque = YES;
    //    tableFooter.font = [UIFont boldSystemFontOfSize:15];
    //    tableFooter.text = @"加载中...";
    //loadMoreFooterView = [[UIView alloc] initWithFrame:footerRect];
    //[loadMoreFooterView addSubview:tableFooter];
    loadMoreFooterView = [UIView loadMoreFooterView];

    // initial no more table footer view
    //tableFooter.text = @"没有更多了";
    //noMoreFooterView = [[UIView alloc] initWithFrame:footerRect];
    //[noMoreFooterView addSubview:tableFooter];
    noMoreFooterView = [UIView noMoreFotterView];

    [self getLocalData];
}

#pragma mark - progress view

- (MBProgressHUD*)progressView
{
    if (_progressView == nil) {
        _progressView = [MBProgressHUD progressHUDNetworkLoadingInView:self.view];
        [self.view addSubview:_progressView];
    }
    return _progressView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return [self.durationList count];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.competitionList objectAtIndex:section] count];
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.durationList objectAtIndex:section];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* competitionTableViewIdentifier = @"CompetitionTableViewIdentifier";
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:competitionTableViewIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:competitionTableViewIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = [[self.competitionList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView*)tableView willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{

    // judge to load more.
    if (hasMore && indexPath.section == [self.durationList count] - 1 && indexPath.row == [[self.competitionList lastObject] count] - 1) {

        self.tableView.tableFooterView = loadMoreFooterView;

        [self performSelectorInBackground:@selector(pullupGetMore) withObject:nil];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#warning 这里需要你调整。。。。。传递到下一个页面的competition
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    MatchViewController* matchViewController = [self.storyboard instantiateViewControllerWithIdentifier:[UIViewController matchViewControllerIdentifier]];
    NSLog(@"%@", [Competition MR_findFirst]);
    matchViewController.competition = [Competition MR_findFirst];
    //matchViewController.competition = self.competitionList[indexPath.section][indexPath.row];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// 获取数据

// drop-dwon refresh --- get latest data from server
- (void)dropdownRefresh
{

    // request latest server data
    [[CompetitionManager sharedCompetitionManager] getLatestCompetitionsFromNetworkWithType:[NSNumber numberWithInt:self.campusType] limit:10 complete:^(NSArray* results, NSError* error) {
        [self.progressView removeFromSuperview];
        if (error) {
            // something wrong
            NSLog(@"%@",error);
        } else {
            // get latest server data & remove all old table data
            [self handleCompetitionDataList:results resetSign:true];
            // close progress view
            //[MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
            
        }
        
        // 关闭上拉下拉刷新
        [header endRefreshing];
        //        [footer endRefreshing];
    }];
}

// get local data --- when first enter this page
- (void)getLocalData
{
    //    // empty old table data
    //    [self.durationList removeAllObjects];
    //    [self.competitionList removeAllObjects];

    // load all local data
    NSArray* results = [[CompetitionManager sharedCompetitionManager] getCompetitionsFromCoreDataWithType:[NSNumber numberWithInt:self.campusType]];

    // check local data count
    if ([results count] == 0) {
        // initial hud progress view
        //MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        // MBProgressHUD* hud=[MBProgressHUD ]
        //hud.labelText = @"加载中";

        [self.progressView show:YES];

        // local data is empty
        [self dropdownRefresh];
    } else {
        // local data is not empty & remove all old table data
        [self handleCompetitionDataList:results resetSign:true];
    }
}

// pull-up get more --- get earlier server data
- (void)pullupGetMore
{
    // find the last competition we have
    Competition* lastCompetition = [[[CompetitionManager sharedCompetitionManager] getCompetitionsFromCoreDataWithType:[NSNumber numberWithInt:self.campusType]] lastObject];

    // check if last competition is null
    if (lastCompetition == nil) {
        // can not get more data using last object.
        hasMore = false;
        self.tableView.tableFooterView = noMoreFooterView;
    } else {
        // can get more data using last object.

        // get more data from server
        [[CompetitionManager sharedCompetitionManager] getEarlierCompetitionsFromNetwork:[lastCompetition competitionId] withType:@(1) limit:10 complete:^(NSArray* results, NSError* error) {
            
            if (error) {
                // something wrong
                NSLog(@"%@",error);
            } else {
                // 检测是否还有更多
                if ([results count] == 0) {
                    hasMore = false;
                    self.tableView.tableFooterView = noMoreFooterView;
                } else {
                    // get more server data
                    [self handleCompetitionDataList:results resetSign:false];
                }
            }
            
            // 关闭上拉下拉刷新
            [header endRefreshing];
            //        [footer endRefreshing];
        }];
    }
}

// 辅助函数
// handle data list --- convert list to table data & reload table data
- (void)handleCompetitionDataList:(NSArray*)dataList resetSign:(BOOL)sign
{
    BOOL firstGroupSign = true;
    NSString* tempCompetitionDuration;
    NSMutableArray* tempComptitionArray = [[NSMutableArray alloc] init];

    if (sign) {
        hasMore = true;
        [self.competitionList removeAllObjects];
        [self.durationList removeAllObjects];
    }

    for (Competition* competition in dataList) {
        if (![tempCompetitionDuration isEqualToString:[competition time]]) {
            // new temp competition array
            if (firstGroupSign) {
                firstGroupSign = false;
            } else {
                [self.competitionList addObject:tempComptitionArray];
                [self.durationList addObject:[self convertTimetoString:tempCompetitionDuration]];
            }
            tempCompetitionDuration = [competition time];
            tempComptitionArray = [[NSMutableArray alloc] init];
        }
        // add to last competition array
        [tempComptitionArray addObject:[competition name]];
    }

    [self.competitionList addObject:tempComptitionArray];
    [self.durationList addObject:[self convertTimetoString:tempCompetitionDuration]];

    [self.tableView reloadData];
}

// convert competition time
- (NSString*)convertTimetoString:(NSString*)time
{
    //    NSString *year = [time substringToIndex:[time length]-1];

    if ([[time substringFromIndex:[time length] - 1] isEqualToString:@"1"]) {
        return [NSString stringWithFormat:@"%@年上学期", [time substringToIndex:[time length] - 1]];
    } else {
        return [NSString stringWithFormat:@"%@年下学期", [time substringToIndex:[time length] - 1]];
    }
}

// 上下拉， 刷新以及下载更多
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView*)refreshView
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH : mm : ss.SSS";
    if (header == refreshView) { // 刷新数据
        [self dropdownRefresh];
    } else { // 加载更多数据
        [self pullupGetMore];
    }
}

#pragma mark -

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
}

@end
