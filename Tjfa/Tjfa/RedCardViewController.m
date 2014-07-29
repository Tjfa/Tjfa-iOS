//
//  RedCardViewController.m
//  Tjfa
//
//  Created by 邱峰 on 7/21/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "RedCardViewController.h"
#import "RedCardTableViewCell.h"
#import "PlayerManager.h"

@interface RedCardViewController ()

@end

@implementation RedCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - set cell
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* redCardCellIdentifier = @"RedCardTableViewCell";
    RedCardTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:redCardCellIdentifier];
    [cell setCellWithPlayer:self.data[indexPath.row]];
    return cell;
}

- (NSComparisonResult)comparedPlayer:(Player*)a withB:(Player*)b
{
    if ([b.yellowCard isEqual:a.yellowCard]) {
        return [a.playerId compare:b.playerId];
    } else
        return [b.redCard compare:a.redCard];
}

#pragma mark - implement super class method

- (void)getDataFromNetwork:(Competition*)competition complete:(void (^)(NSArray*, NSError*))complete
{
    __weak RedCardViewController* weakSelf = self;
    [[PlayerManager sharedPlayerManager] getPlayersByCompetitionFromNetwork:competition complete:^(NSArray* result, NSError* error) {
        if (!error){
            NSArray* array=[result sortedArrayUsingComparator:^NSComparisonResult(Player* a, Player*b){
                return [weakSelf comparedPlayer:a withB:b];
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
    __weak RedCardViewController* weakSelf = self;
    return [[[PlayerManager sharedPlayerManager] getPlayersByCompetitionFromCoreData:competition] sortedArrayUsingComparator:^NSComparisonResult(Player* a, Player* b) {
        return [weakSelf comparedPlayer:a withB:b];
    }];
}

- (NSArray*)getDataFromCoreDataCompetition:(Competition*)competition whenSearch:(NSString*)key
{
    __weak RedCardViewController* weakSelf = self;
    return [[[PlayerManager sharedPlayerManager] getPlayersByKey:key competition:competition] sortedArrayUsingComparator:^NSComparisonResult(Player* a, Player* b) {
        return [weakSelf comparedPlayer:a withB:b];
    }];
}

@end
