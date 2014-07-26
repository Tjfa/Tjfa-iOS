//
//  TeamViewController.m
//  Tjfa
//
//  Created by 邱峰 on 7/26/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "TeamViewController.h"
#import "TeamTableViewCell.h"
#import "TeamManager.h"

@interface TeamViewController ()

@end

@implementation TeamViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - set cell
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* teamTableCellIdentifier = @"TeamTableViewCell";
    TeamTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:teamTableCellIdentifier];
    [cell setCellWithTeam:self.data[indexPath.row]];
    return cell;
}

#pragma mark - compare
- (NSComparisonResult)comparedRank:(Team*)a andTeamB:(Team*)b
{
    if ([a.rank intValue] == 100) {
        return NSOrderedDescending;
    } else {
        return [a.rank compare:b.rank];
    }
}

#pragma mark - implement super class method
- (void)getDataFromNetwork:(Competition*)competition
                  complete:(void (^)(NSArray*, NSError*))complete
{
    __weak TeamViewController* weakSelf = self;
    [[TeamManager sharedTeamManager] getTeamsFromNetwork:competition complete:^(NSArray* results, NSError* error) {
        if (!error){
            NSArray* array=[results sortedArrayUsingComparator:^NSComparisonResult(Team* a, Team* b){
                return [weakSelf comparedRank:a andTeamB:b];
     
            }];
            weakSelf.completeBlock(array,nil);
        }
        else{
            weakSelf.completeBlock(nil,error);
        }
    }];
}

- (NSArray*)getDataFromCoreDataCompetition:(Competition*)competition
{
    __weak TeamViewController* weakSelf = self;
    return [[[TeamManager sharedTeamManager] getTeamsFromCoreDataWithCompetition:competition] sortedArrayUsingComparator:^NSComparisonResult(Team* a, Team* b) {
        return [weakSelf comparedRank:a andTeamB:b];
    }];
}

- (NSArray*)getDataFromCoreDataCompetition:(Competition*)competition whenSearch:(NSString*)key
{
    __weak TeamViewController* weakSelf = self;
    return [[[TeamManager sharedTeamManager] getTeamsByKey:key competition:competition] sortedArrayUsingComparator:^NSComparisonResult(Team* a, Team* b) {
        return [weakSelf comparedRank:a andTeamB:b];
    }];
}

@end
