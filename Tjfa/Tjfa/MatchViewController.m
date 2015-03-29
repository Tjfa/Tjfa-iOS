//
//  MatchViewController.m
//  Tjfa
//
//  Created by 邱峰 on 7/16/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "MatchViewController.h"
#import "MatchManager.h"
#import "MatchTableViewCell.h"

@interface MatchViewController ()

@end

@implementation MatchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"matchBg"]];
}

#pragma mark - set cell

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* cellIdentifier = @"MatchTableViewCell";

    MatchTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    [cell setCellWithMatch:self.data[indexPath.row]];
    return cell;
}

#pragma mark - implement super class method

- (void)getDataFromNetwork:(Competition*)competition complete:(void (^)(NSArray*, NSError*))complete
{
    __weak MatchViewController* weakSelf = self;
    [[MatchManager sharedMatchManager] getMatchesByCompetitionFromNetwork:competition complete:^(NSArray* results, NSError* error) {
        if (weakSelf){
            weakSelf.completeBlock(results,error);
        }
    }];
}

- (NSArray*)getDataFromCoreDataCompetition:(Competition*)compeition
{
    return [[MatchManager sharedMatchManager] getMatchesByCompetitionFromCoreData:compeition];
}

- (NSArray*)getDataFromCoreDataCompetition:(Competition*)competition whenSearch:(NSString*)key
{
    return [[MatchManager sharedMatchManager] getMatchesByTeamName:key competition:competition];
}

@end
