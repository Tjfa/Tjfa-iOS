//
//  YellowCardViewController.m
//  Tjfa
//
//  Created by 邱峰 on 7/17/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "TJYellowCardViewController.h"
#import "TJPlayerManager.h"
#import "TJYellowCardTableViewCell.h"

@interface TJYellowCardViewController ()

@end

@implementation TJYellowCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yellowCardBg"]];
    // Do any additional setup after loading the view.
}

#pragma mark - set cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TJYellowCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(TJYellowCardTableViewCell.class)];
    [cell setCellWithPlayer:self.data[indexPath.row]];
    return cell;
}

- (NSComparisonResult)comparedPlayer:(Player *)a withB:(Player *)b
{
    if ([b.yellowCard isEqual:a.yellowCard]) {
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
        return [b.yellowCard compare:a.yellowCard];
}

#pragma mark - implement super class method

- (void)getDataFromNetwork:(Competition *)competition complete:(void (^)(NSArray *, NSError *))complete
{
    __weak TJYellowCardViewController *weakSelf = self;
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
        return  [weakSelf comparedPlayer:a withB:b];
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
