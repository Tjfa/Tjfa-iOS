//
//  MenuViewController.m
//  Tjfa
//
//  Created by 邱峰 on 7/16/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "MenuViewController.h"
#import <RESideMenu.h>
#import "CompetitionDetailViewController.h"

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
    CompetitionDetailViewController* viewController;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == MATCH_VIEW_CONTROLLER_INDEX) {
        viewController = [self.storyboard instantiateViewControllerWithIdentifier:[UIViewController matchViewControllerIdentifier]];
        self.sideMenuViewController.navigationItem.title = @"比 赛";

    } else if (indexPath.row == SCORE_LIST_VIEW_CONTROLLER_INDEX) {

        viewController = [self.storyboard instantiateViewControllerWithIdentifier:[UIViewController scoreListViewControllerIdentifier]];
        self.sideMenuViewController.navigationItem.title = @"射手榜";

    } else if (indexPath.row == YELLOW_CARD_VIEW_CONTROLLER_INDEX) {

        viewController = [self.storyboard instantiateViewControllerWithIdentifier:[UIViewController yellowCardViewControllerIdentifier]];
        self.sideMenuViewController.navigationItem.title = @"黄 牌";

    } else if (indexPath.row == RED_CARD_VIEW_CONTROLLER_INDEX) {

        viewController = [self.storyboard instantiateViewControllerWithIdentifier:[UIViewController redCardViewControllerIdentifier]];
        self.sideMenuViewController.navigationItem.title = @"红 牌";

    } else if (indexPath.row == GROUP_SCORE_VIEW_CONTROLLER_INDEX) {

        viewController = [self.storyboard instantiateViewControllerWithIdentifier:[UIViewController groupScoreViewController]];
        self.sideMenuViewController.navigationItem.title = @"积 分";

    } else if (indexPath.row == TEAM_VIEW_CONTROLLER_INDEX) {
        viewController = [self.storyboard instantiateViewControllerWithIdentifier:[UIViewController teamViewController]];
        self.sideMenuViewController.navigationItem.title = @"球 队";
    }

    if (viewController) {
        [self.sideMenuViewController setContentViewController:viewController animated:YES];
        [self.sideMenuViewController hideMenuViewController];
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
