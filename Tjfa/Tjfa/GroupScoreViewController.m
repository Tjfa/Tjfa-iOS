//
//  GroupScoreViewController.m
//  Tjfa
//
//  Created by 邱峰 on 7/22/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "GroupScoreViewController.h"
#import "Team.h"
#import "TeamManager.h"
#import "RootViewController.h"
#import "GroupScoreCell.h"
#import <RESideMenu.h>

@interface GroupScoreViewController ()

@property (nonatomic, strong) NSMutableDictionary* groupData;
@property (nonatomic, strong) NSArray* keyData;

@end

@implementation GroupScoreViewController

@synthesize groupData = _groupData;
@synthesize data = _data;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"groupBg"]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - reset data

- (NSMutableDictionary*)groupData
{
    if (_groupData == nil) {
        _groupData = [[NSMutableDictionary alloc] init];
    }
    return _groupData;
}

- (NSArray*)keyData
{
    if (_keyData == nil) {
        [self data];
        if (_keyData == nil) {
            _keyData = [[NSArray alloc] init];
        }
    }
    return _keyData;
}

- (NSArray*)data
{

    if (_data == nil) {
        __weak RootViewController* rootViewController = (RootViewController*)self.sideMenuViewController;
        [self setData:[self getDataFromCoreDataCompetition:rootViewController.competition]];
        if (_data == nil || _data.count == 0) {
            [self getLasterData:YES];
        }
    }
    return _data;
}

- (NSComparisonResult)comparedTeam:(Team*)a andTeam:(Team*)b
{
    if (![a.score isEqual:b.score]) {
        return [b.score compare:a.score];
    } else {
        int goalA = [a.groupGoalCount intValue];
        int goalB = [b.groupGoalCount intValue];
        int missA = [a.groupMissCount intValue];
        int missB = [b.groupMissCount intValue];
        if (goalA - missA != goalB - missB) {
            int winA = goalA - missA;
            int winB = goalB - missB;
            if (winA > winB)
                return NSOrderedAscending;
            else
                return NSOrderedDescending;
        } else {
            if (goalA > goalB)
                return NSOrderedAscending;
            else if (goalA == goalB)
                return NSOrderedSame;
            else
                return NSOrderedDescending;
        }
    }
}

- (void)setData:(NSArray*)data
{
    if (_data != data) {
        _data = data;
        [self.groupData removeAllObjects];

        for (Team* team in data) {
            NSMutableArray* arr = self.groupData[team.groupNo];
            if (arr == nil) {
                arr = [[NSMutableArray alloc] init];
                self.groupData[team.groupNo] = arr;
            }
            [arr addObject:team];
        }
        self.keyData = [[self.groupData allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSString* a, NSString* b) {
            return [a compare:b];
        }];

        __weak GroupScoreViewController* weakSelf = self;
        for (NSString* key in self.keyData) {
            [self.groupData[key] sortUsingComparator:^NSComparisonResult(Team* a, Team* b) {
                return [weakSelf comparedTeam:a andTeam:b];
            }];

            NSLog(@"%@", key);
            for (Team* team in self.groupData[key]) {
                NSLog(@"%@", team.name);
            }
        }
    }
}

#pragma mark - override tableview delegate & datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return self.keyData.count;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray* arr = self.groupData[self.keyData[section]];
    return arr.count;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc] init];
    view.backgroundColor = [UIColor appRedColor];
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 320 - 15, 30)];
    title.textColor = [UIColor whiteColor];
    title.text = self.keyData[section];
    [view addSubview:title];
    return view;
}

- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc] init];
    view.backgroundColor = [UIColor appRedColor];
    return view;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* cellIdentifier = @"GroupScoreCell";
    GroupScoreCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSMutableArray* arr = self.groupData[self.keyData[indexPath.section]];
    [cell setCellWithTeam:arr[indexPath.row]];
    return cell;
}

#pragma mark - implementation super class

- (void)getDataFromNetwork:(Competition*)competition complete:(void (^)(NSArray*, NSError*))complete
{
    __weak GroupScoreViewController* weakSelf = self;
    [[TeamManager sharedTeamManager] getTeamsFromNetwork:competition complete:^(NSArray* results, NSError* error) {
        if (weakSelf){
            weakSelf.completeBlock(results,error);
        }
    }];
}

- (NSArray*)getDataFromCoreDataCompetition:(Competition*)compeition
{
    return [[TeamManager sharedTeamManager] getTeamsFromCoreDataWithCompetition:compeition];
}

- (NSArray*)getDataFromCoreDataCompetition:(Competition*)competition whenSearch:(NSString*)key
{
    NSArray* array = [[TeamManager sharedTeamManager] getTeamsByKey:key competition:competition];
    __weak GroupScoreViewController* weakSelf = self;
    return [array sortedArrayUsingComparator:^NSComparisonResult(Team* a, Team* b) {
        return [weakSelf comparedTeam:a andTeam:b];
    }];
}

@end
