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
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yellowCardBg"]];
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

- (NSComparisonResult)comparedPlayer:(Player*)a withB:(Player*)b
{
    if ([b.yellowCard isEqual:a.yellowCard]) {
        return [a.playerId compare:b.playerId];
    } else
        return [b.yellowCard compare:a.yellowCard];
}

#pragma mark - implement super class method

- (void)getDataFromNetwork:(Competition*)competition complete:(void (^)(NSArray*, NSError*))complete
{
    __weak YellowCardViewController* weakSelf = self;
    [[PlayerManager sharedPlayerManager] getPlayersByCompetitionFromNetwork:competition complete:^(NSArray* result, NSError* error) {
        if (weakSelf){
            if (!error){
                NSArray* array=[result sortedArrayUsingComparator:^NSComparisonResult(Player* a, Player*b){
                    return [weakSelf comparedPlayer:a withB:b];
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
    __weak YellowCardViewController* weakSelf = self;
    return [[[PlayerManager sharedPlayerManager] getPlayersByCompetitionFromCoreData:competition] sortedArrayUsingComparator:^NSComparisonResult(Player* a, Player* b) {
        return  [weakSelf comparedPlayer:a withB:b];
    }];
}

- (NSArray*)getDataFromCoreDataCompetition:(Competition*)competition whenSearch:(NSString*)key
{
    __weak YellowCardViewController* weakSelf = self;

    return [[[PlayerManager sharedPlayerManager] getPlayersByKey:key competition:competition] sortedArrayUsingComparator:^NSComparisonResult(Player* a, Player* b) {
        return [weakSelf comparedPlayer:a withB:b];
    }];
}

@end
