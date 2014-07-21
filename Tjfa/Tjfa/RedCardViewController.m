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
    [[PlayerManager sharedPlayerManager] getPlayersByCompetitionFromNetwork:competition complete:complete];
}

- (NSArray*)getDataFromCoreDataCompetition:(Competition*)compeition
{
    return [[PlayerManager sharedPlayerManager] getPlayersByCompetitionFromCoreData:compeition];
}

- (NSArray*)getDataFromCoreDataCompetition:(Competition*)competition whenSearch:(NSString*)key
{
    return [[PlayerManager sharedPlayerManager] getPlayersByKey:key competition:competition];
}

@end
