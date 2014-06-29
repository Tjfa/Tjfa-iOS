//
//  MatchListViewController.m
//  Tjfa
//
//  Created by JackYu on 6/29/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "MatchListViewController.h"
#import "CompetitionManager.h"

@interface MatchListViewController ()
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
    
    [super viewDidLoad];
    NSMutableArray *firstArray = [[NSMutableArray alloc] initWithArray:@[@"first",@"second",@"third"]];
    NSMutableArray *secondAray = [[NSMutableArray alloc]initWithArray:@[@"test1",@"test2",@"test3"]];
    self.competionList = [[NSMutableArray alloc] init];
    self.durationList = [[NSMutableArray alloc] init];
    [self.durationList addObject:@"2014年第二学期"];
    [self.competionList addObject:firstArray];
    [self.durationList addObject:@"2014年第一学期"];
    [self.competionList addObject:secondAray];
    
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
    // empty old table data
    [self.durationList removeAllObjects];
    [self.competionList removeAllObjects];
    
    // request latest server data
    [[CompetitionManager sharedCompetitionManager] getLatestCompetitionsFromNetworkWithType:@(1) limit:10 complete:^(NSArray *results, NSError *error){
        if (error) {
            // something wrong
            NSLog(@"%@",error);
        } else {
            // get latest server data
            [self handleCompetitionDataList:results];
        }
    }];
}

// get local data --- when first enter this page
- (void) getLocalData {
    // empty old table data
    [self.durationList removeAllObjects];
    [self.competionList removeAllObjects];
    
    // load all local data
    NSArray *results = [[CompetitionManager sharedCompetitionManager] getCompetitionsFromCoreDataWithType:@(1)];
    
    // check local data count
    if ([results count] ==0) {
        // local data is empty
        [self dropdownRefresh];
    } else {
        // local data is not empty
        [self handleCompetitionDataList:results];
    }
}

// pull-up get more --- get earlier server data
- (void) pullupGetMore {
    // find the last competition we have
    Competition *lastCompetition = [[self.competionList lastObject] lastObject];
    
    // get more data from server
    [[CompetitionManager sharedCompetitionManager] getEarlierCompetitionsFromNetwork:[lastCompetition competitionId] withType:@(1) limit:10 complete:^(NSArray *results, NSError *error){
        if (error) {
            // something wrong
            NSLog(@"%@",error);
        } else {
            // get more server data
            [self handleCompetitionDataList:results];
        }
    }];
}

// handle data list --- convert list to table data & reload table data
- (void) handleCompetitionDataList:(NSArray *)dataList {
    BOOL firstGroupSign = true;
    NSString *tempCompetitionDuration;
    NSMutableArray *tempComptitionArray = [[NSMutableArray alloc] init];
    for (Competition *competition in dataList) {
        if (![tempCompetitionDuration isEqualToString:[competition time]]) {
            // new temp competition array
            if (firstGroupSign) {
                firstGroupSign = false;
            } else {
                [self.competionList addObject:tempComptitionArray];
                [self.durationList addObject:tempCompetitionDuration];
            }
            tempCompetitionDuration = [competition time];
            tempComptitionArray = [[NSMutableArray alloc] init];
        }
        // add to last competition array
        [tempComptitionArray addObject:[competition name]];
    }
    
    [self.competionList addObject:tempComptitionArray];
    [self.durationList addObject:tempCompetitionDuration];
    
    [self.tableView reloadData];
}

@end
