//
//  MatchViewController.m
//  Tjfa
//
//  Created by 邱峰 on 7/16/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "TJMatchViewController.h"
#import "TJMatchManager.h"
#import "TJMatchTableViewCell.h"

@interface TJMatchViewController ()

@end

@implementation TJMatchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"matchBg"]];
}

#pragma mark - set cell

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TJMatchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(TJMatchTableViewCell.class)];

    [cell setCellWithMatch:self.data[indexPath.row]];
    return cell;
}

#pragma mark - implement super class method

- (void)getDataFromNetwork:(Competition *)competition complete:(void (^)(NSArray *, NSError *))complete
{
    __weak typeof(self) weakSelf = self;
    [[TJMatchManager sharedMatchManager] getMatchesByCompetitionFromNetwork:competition complete:^(NSArray *results, NSError *error) {
        if (weakSelf){
            weakSelf.completeBlock(results,error);
        }
    }];
}

- (NSArray *)getDataFromCoreDataCompetition:(Competition *)compeition
{
    return [[TJMatchManager sharedMatchManager] getMatchesByCompetitionFromCoreData:compeition];
}

- (NSArray *)getDataFromCoreDataCompetition:(Competition *)competition whenSearch:(NSString *)key
{
    return [[TJMatchManager sharedMatchManager] getMatchesByTeamName:key competition:competition];
}

@end
