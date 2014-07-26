//
//  YellowCardViewController.m
//  Tjfa
//
//  Created by 邱峰 on 7/17/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "YellowCardViewController.h"
#import "PlayerManager.h"
#import "YellowCardTableViewCell.h"

@interface YellowCardViewController ()

@end

@implementation YellowCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - set cell
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* yellowCardCellIdentifier = @"YellowCardTableViewCell";
    YellowCardTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:yellowCardCellIdentifier];
    [cell setCellWithPlayer:self.data[indexPath.row]];
    return cell;
}

#pragma mark - implement super class method

- (void)getDataFromNetwork:(Competition*)competition complete:(void (^)(NSArray*, NSError*))complete
{
    __weak YellowCardViewController* weakSelf = self;
    [[PlayerManager sharedPlayerManager] getPlayersByCompetitionFromNetwork:competition complete:^(NSArray* result, NSError* error) {
        if (!error){
            NSArray* array=[result sortedArrayUsingComparator:^NSComparisonResult(Player* a, Player*b){
                return [b.yellowCard compare:a.yellowCard];       //从高到低排序
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
        return [b.yellowCard compare:a.yellowCard];
    }];
}

- (NSArray*)getDataFromCoreDataCompetition:(Competition*)competition whenSearch:(NSString*)key
{
    return [[[PlayerManager sharedPlayerManager] getPlayersByKey:key competition:competition] sortedArrayUsingComparator:^NSComparisonResult(Player* a, Player* b) {
        return [b.yellowCard compare:a.yellowCard];
    }];
}

@end
