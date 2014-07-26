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

#pragma mark - implement super class method

- (void)getDataFromNetwork:(Competition*)competition complete:(void (^)(NSArray*, NSError*))complete
{
    __weak RedCardViewController* weakSelf = self;
    [[PlayerManager sharedPlayerManager] getPlayersByCompetitionFromNetwork:competition complete:^(NSArray* result, NSError* error) {
        if (!error){
            NSArray* array=[result sortedArrayUsingComparator:^NSComparisonResult(Player* a, Player*b){
                return [b.redCard compare:a.redCard];       //从高到低排序
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
    return [[[PlayerManager sharedPlayerManager] getPlayersByCompetitionFromCoreData:competition] sortedArrayUsingComparator:^NSComparisonResult(Player* a, Player* b) {
        return [b.redCard compare:a.redCard];
    }];
}

- (NSArray*)getDataFromCoreDataCompetition:(Competition*)competition whenSearch:(NSString*)key
{
    return [[[PlayerManager sharedPlayerManager] getPlayersByKey:key competition:competition] sortedArrayUsingComparator:^NSComparisonResult(Player* a, Player* b) {
        return [b.redCard compare:a.redCard];
    }];
}

@end
