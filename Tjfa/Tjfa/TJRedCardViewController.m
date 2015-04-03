//
//  RedCardViewController.m
//  Tjfa
//
//  Created by 邱峰 on 7/21/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "TJRedCardViewController.h"
#import "TJRedCardTableViewCell.h"
#import "TJPlayerManager.h"

@interface TJRedCardViewController ()

@end

@implementation TJRedCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"redCardBg"]];
}

#pragma mark - set cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TJRedCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(TJRedCardTableViewCell.class)];
    [cell setCellWithPlayer:self.data[indexPath.row]];
    return cell;
}

- (NSComparisonResult)comparedPlayer:(Player *)a withB:(Player *)b
{
    if ([b.redCard isEqual:a.redCard]) {
        if ([a.name isEqualToString:@"邱峰"]) {
            return NSOrderedAscending;
        }
        else if ([b.name isEqualToString:@"邱峰"]) {
            return NSOrderedDescending;
        }
        else {
            return [a.playerId compare:b.playerId];
        }
    }
    else
        return [b.redCard compare:a.redCard];
}

#pragma mark - implement super class method

- (void)getDataFromNetwork:(Competition *)competition complete:(void (^)(NSArray *, NSError *))complete
{
    __weak typeof(self) weakSelf = self;
    [[TJPlayerManager sharedPlayerManager] getPlayersByCompetitionFromNetwork:competition complete:^(NSArray *result, NSError *error) {
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

- (NSArray *)getDataFromCoreDataCompetition:(Competition *)competition
{
    __weak typeof(self) weakSelf = self;
    return [[[TJPlayerManager sharedPlayerManager] getPlayersByCompetitionFromCoreData:competition] sortedArrayUsingComparator:^NSComparisonResult(Player *a, Player *b) {
        return [weakSelf comparedPlayer:a withB:b];
    }];
}

- (NSArray *)getDataFromCoreDataCompetition:(Competition *)competition whenSearch:(NSString *)key
{
    __weak typeof(self) weakSelf = self;
    return [[[TJPlayerManager sharedPlayerManager] getPlayersByKey:key competition:competition] sortedArrayUsingComparator:^NSComparisonResult(Player *a, Player *b) {
        return [weakSelf comparedPlayer:a withB:b];
    }];
}

@end
