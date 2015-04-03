//
//  TeamViewController.m
//  Tjfa
//
//  Created by 邱峰 on 7/26/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "TJTeamViewController.h"
#import "TJTeamTableViewCell.h"
#import "TJTeamManager.h"

@interface TJTeamViewController ()

@end

@implementation TJTeamViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"teamBg"]];
    // Do any additional setup after loading the view.
}

#pragma mark - set cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TJTeamTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(TJTeamTableViewCell.class)];
    [cell setCellWithTeam:self.data[indexPath.row]];
    return cell;
}

#pragma mark - compare
- (NSComparisonResult)comparedRank:(Team *)a andTeamB:(Team *)b
{
    if ([a.rank isEqual:b.rank]) {
        return [a.teamId compare:b.teamId];
    }
    else {
        if ([a.rank intValue] == 100) {
            return NSOrderedDescending;
        }
        else if ([b.rank intValue] == 100) {
            return NSOrderedAscending;
        }
        else if ([a.rank intValue] == 0) {
            return NSOrderedDescending;
        }
        else if ([b.rank intValue] == 0) {
            return NSOrderedAscending;
        }
        else {
            return [a.rank compare:b.rank];
        }
    }
}

#pragma mark - implement super class method
- (void)getDataFromNetwork:(Competition *)competition
                  complete:(void (^)(NSArray *, NSError *))complete
{
    __weak typeof(self) weakSelf = self;
    [[TJTeamManager sharedTeamManager] getTeamsFromNetwork:competition complete:^(NSArray *results, NSError *error) {
        if (weakSelf){
            if (!error) {
                NSArray* array=[results sortedArrayUsingComparator:^NSComparisonResult(Team* a, Team* b){
                    return [weakSelf comparedRank:a andTeamB:b];
     
                }];
                weakSelf.completeBlock(array,nil);
            }
            else{
                weakSelf.completeBlock(nil,error);
            }
        }
    }];
}

- (NSArray *)getDataFromCoreDataCompetition:(Competition *)competition
{
    __weak typeof(self) weakSelf = self;
    return [[[TJTeamManager sharedTeamManager] getTeamsFromCoreDataWithCompetition:competition] sortedArrayUsingComparator:^NSComparisonResult(Team *a, Team *b) {
        return [weakSelf comparedRank:a andTeamB:b];
    }];
}

- (NSArray *)getDataFromCoreDataCompetition:(Competition *)competition whenSearch:(NSString *)key
{
    __weak typeof(self) weakSelf = self;
    return [[[TJTeamManager sharedTeamManager] getTeamsByKey:key competition:competition] sortedArrayUsingComparator:^NSComparisonResult(Team *a, Team *b) {
        return [weakSelf comparedRank:a andTeamB:b];
    }];
}

@end
