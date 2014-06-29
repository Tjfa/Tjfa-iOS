//
//  MatchListViewController.m
//  Tjfa
//
//  Created by JackYu on 6/29/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "MatchListViewController.h"
#import "CompetitionManager.h"

@interface MatchListViewController (){
    MJRefreshHeaderView *header;
    MJRefreshFooterView *footer;
}
@property(nonatomic, strong)NSMutableArray *durationList;
@property(nonatomic, strong)NSMutableArray *competionList;

@end

@implementation MatchListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    
    if (self.campusType == 0) {
        self.navigationItem.title = @"本部赛事";
    } else {
        self.navigationItem.title = @"嘉定赛事";
    }
    
    NSMutableArray *firstArray = [[NSMutableArray alloc] initWithArray:@[@"first",@"second",@"third"]];
    NSMutableArray *secondAray = [[NSMutableArray alloc]initWithArray:@[@"test1",@"test2",@"test3"]];
    self.competionList = [[NSMutableArray alloc] init];
    self.durationList = [[NSMutableArray alloc] init];
    [self.durationList addObject:@"2014年第二学期"];
    [self.competionList addObject:firstArray];
    [self.durationList addObject:@"2014年第一学期"];
    [self.competionList addObject:secondAray];
    
    // 注册上拉下拉刷新控件
    header = [[MJRefreshHeaderView alloc] init];
    header.delegate = self;
    header.scrollView = self.tableView;
    
    footer = [[MJRefreshFooterView alloc] init];
    footer.delegate = self;
    footer.scrollView = self.tableView;
    
    [self getLocalData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (int)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.durationList count];
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.competionList objectAtIndex:section] count];
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.durationList objectAtIndex:section];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *matchListTableViewIdentifier = @"MatchListTableViewIdentifier";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:matchListTableViewIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:matchListTableViewIdentifier];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = [[self.competionList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    return cell;
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
- (void) dropdownRefresh{
    
    // request latest server data
    [[CompetitionManager sharedCompetitionManager] getLatestCompetitionsFromNetworkWithType:[NSNumber numberWithInt:self.campusType] limit:10 complete:^(NSArray *results, NSError *error){
        if (error) {
            // something wrong
            NSLog(@"%@",error);
        } else {
            // get latest server data & remove all old table data
            [self handleCompetitionDataList:results resetSign:true];
        }
        
        // 关闭上拉下拉刷新
        [header endRefreshing];
        [footer endRefreshing];
    }];
}

// get local data --- when first enter this page
- (void) getLocalData {
//    // empty old table data
//    [self.durationList removeAllObjects];
//    [self.competionList removeAllObjects];
    
    // load all local data
    NSArray *results = [[CompetitionManager sharedCompetitionManager] getCompetitionsFromCoreDataWithType:[NSNumber numberWithInt:self.campusType]];
    
    // check local data count
    if ([results count] ==0) {
        // local data is empty
        [self dropdownRefresh];
    } else {
        // local data is not empty & remove all old table data
        [self handleCompetitionDataList:results resetSign:true];
    }
}

// pull-up get more --- get earlier server data
- (void) pullupGetMore {
    // find the last competition we have
    Competition *lastCompetition = [[[CompetitionManager sharedCompetitionManager] getCompetitionsFromCoreDataWithType:[NSNumber numberWithInt:self.campusType]] lastObject];
    
    // get more data from server
    [[CompetitionManager sharedCompetitionManager] getEarlierCompetitionsFromNetwork:[lastCompetition competitionId] withType:@(1) limit:10 complete:^(NSArray *results, NSError *error){
        if (error) {
            // something wrong
            NSLog(@"%@",error);
        } else {
            // get more server data
            [self handleCompetitionDataList:results resetSign:false];
        }
        
        // 关闭上拉下拉刷新
        [header endRefreshing];
        [footer endRefreshing];
    }];
}

// 辅助函数
// handle data list --- convert list to table data & reload table data
- (void) handleCompetitionDataList:(NSArray *)dataList resetSign:(BOOL)sign {
    BOOL firstGroupSign = true;
    NSString *tempCompetitionDuration;
    NSMutableArray *tempComptitionArray = [[NSMutableArray alloc] init];
    
    if (sign) {
        [self.competionList removeAllObjects];
        [self.durationList removeAllObjects];
    }
    
    for (Competition *competition in dataList) {
        if (![tempCompetitionDuration isEqualToString:[competition time]]) {
            // new temp competition array
            if (firstGroupSign) {
                firstGroupSign = false;
            } else {
                [self.competionList addObject:tempComptitionArray];
                [self.durationList addObject:[self convertTimetoString:tempCompetitionDuration]];
            }
            tempCompetitionDuration = [competition time];
            tempComptitionArray = [[NSMutableArray alloc] init];
        }
        // add to last competition array
        [tempComptitionArray addObject:[competition name]];
    }
    
    [self.competionList addObject:tempComptitionArray];
    [self.durationList addObject:[self convertTimetoString:tempCompetitionDuration]];
    
    [self.tableView reloadData];
}

// convert competition time
- (NSString*) convertTimetoString:(NSString*)time {
//    NSString *year = [time substringToIndex:[time length]-1];
    
    if ([[time substringFromIndex:[time length]-1] isEqualToString:@"1"]) {
        return [NSString stringWithFormat:@"%@年上学期",[time substringToIndex:[time length]-1]];
    } else {
        return [NSString stringWithFormat:@"%@年下学期",[time substringToIndex:[time length]-1]];
    }
}

// 山下拉， 刷新以及下载更多
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH : mm : ss.SSS";
    if (header == refreshView) { // 刷新数据
        [self dropdownRefresh];
    } else { // 加载更多数据
        [self pullupGetMore];
    }
}

@end
