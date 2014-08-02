//
//  TopScoreViewController.m
//  Tjfa
//
//  Created by 邱峰 on 7/17/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "TopScoreViewController.h"
#import "TopScoreTableViewCell.h"
#import "PlayerManager.h"

@interface TopScoreViewController ()

@end

@implementation TopScoreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"topScoreBg"]];
    // Do any additional setup after loading the view.
}

#pragma mark - set cell
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* topScoreCardCellIdentifier = @"TopScoreTableViewCell";
    TopScoreTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:topScoreCardCellIdentifier];
    [cell setCellWithPlayer:self.data[indexPath.row]];
    return cell;
}

#pragma mark - implement super class method

- (void)getDataFromNetwork:(Competition*)competition complete:(void (^)(NSArray*, NSError*))complete
{
    __weak TopScoreViewController* weakSelf = self;
    [[PlayerManager sharedPlayerManager] getPlayersByCompetitionFromNetwork:competition complete:^(NSArray* result, NSError* error) {
        if (weakSelf){
            if (!error){
                NSArray* array=[result sortedArrayUsingComparator:^NSComparisonResult(Player* a, Player*b){
                    return [b.goalCount compare:a.goalCount];       //从高到低排序
                }];
                weakSelf.completeBlock(array,nil);
            }
            else{
                weakSelf.completeBlock(nil,error);
            }
        }
    }];
}

- (NSArray*)getDataFromCoreDataCompetition:(Competition*)competition
{
    return [[[PlayerManager sharedPlayerManager] getPlayersByCompetitionFromCoreData:competition] sortedArrayUsingComparator:^NSComparisonResult(Player* a, Player* b) {
        return [b.goalCount compare:a.goalCount];
    }];
}

- (NSArray*)getDataFromCoreDataCompetition:(Competition*)competition whenSearch:(NSString*)key
{
    return [[[PlayerManager sharedPlayerManager] getPlayersByKey:key competition:competition] sortedArrayUsingComparator:^NSComparisonResult(Player* a, Player* b) {
        return [b.goalCount compare:a.goalCount];
    }];
}

@end
