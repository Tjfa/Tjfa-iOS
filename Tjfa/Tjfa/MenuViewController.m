//
//  MenuViewController.m
//  Tjfa
//
//  Created by 邱峰 on 7/16/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "MenuViewController.h"
#import <RESideMenu.h>

#import "UIViewController+Identifier.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#define MATCH_VIEW_CONTROLLER_INDEX 0
#define SCORE_LIST_VIEW_CONTROLLER_INDEX 1
#define YELLOW_CARD_VIEW_CONTROLLER_INDEX 2
#define RED_CARD_VIEW_CONTROLLER_INDEX 3
#define GROUP_SCORE_VIEW_CONTROLLER_INDEX 4
#define TEAM_VIEW_CONTROLLER_INDEX 5

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == MATCH_VIEW_CONTROLLER_INDEX) {
        [self.sideMenuViewController setContentViewController:[self.storyboard instantiateViewControllerWithIdentifier:[UIViewController matchViewControllerIdentifier]] animated:YES];
        [self.sideMenuViewController hideMenuViewController];
    } else if (indexPath.row == SCORE_LIST_VIEW_CONTROLLER_INDEX) {
        [self.sideMenuViewController setContentViewController:[self.storyboard instantiateViewControllerWithIdentifier:[UIViewController scoreListViewControllerIdentifier]] animated:YES];
        [self.sideMenuViewController hideMenuViewController];
    } else if (indexPath.row == YELLOW_CARD_VIEW_CONTROLLER_INDEX) {
        [self.sideMenuViewController setContentViewController:[self.storyboard instantiateViewControllerWithIdentifier:[UIViewController yellowCardViewControllerIdentifier]] animated:YES];
        [self.sideMenuViewController hideMenuViewController];
    } else if (indexPath.row == RED_CARD_VIEW_CONTROLLER_INDEX) {
        [self.sideMenuViewController setContentViewController:[self.storyboard instantiateViewControllerWithIdentifier:[UIViewController redCardViewControllerIdentifier]] animated:YES];
    } else if (indexPath.row == GROUP_SCORE_VIEW_CONTROLLER_INDEX) {
        [self.sideMenuViewController setContentViewController:[self.storyboard instantiateViewControllerWithIdentifier:[UIViewController groupScoreViewController]] animated:YES];
    } else if (indexPath.row == TEAM_VIEW_CONTROLLER_INDEX) {
        [self.sideMenuViewController setContentViewController:[self.storyboard instantiateViewControllerWithIdentifier:[UIViewController teamViewController]] animated:YES];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
