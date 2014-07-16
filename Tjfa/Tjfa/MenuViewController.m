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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self.sideMenuViewController setContentViewController:[self.storyboard instantiateViewControllerWithIdentifier:[UIViewController matchViewControllerIdentifier]] animated:YES];
        [self.sideMenuViewController hideMenuViewController];
    } else if (indexPath.row == 1) {
        [self.sideMenuViewController setContentViewController:[self.storyboard instantiateViewControllerWithIdentifier:[UIViewController playerViewControllerIdentifier]] animated:YES];
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
