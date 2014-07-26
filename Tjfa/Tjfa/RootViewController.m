//
//  RootViewController.m
//  Tjfa
//
//  Created by 邱峰 on 7/16/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "RootViewController.h"
#import "UIViewController+Identifier.h"

@interface RootViewController () <RESideMenuDelegate>

@end

@implementation RootViewController {
    BOOL isShow;
}

- (void)awakeFromNib
{
    self.menuPreferredStatusBarStyle = UIStatusBarStyleLightContent;
    UIViewController* viewController = [self.storyboard instantiateViewControllerWithIdentifier:[UIViewController matchViewControllerIdentifier]];
    self.contentViewController = viewController;
    self.rightMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:[UIViewController menuViewControllerIdentifier]];
    self.delegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.clipsToBounds = YES;
}

- (IBAction)toggleMenu:(id)sender
{
    if (isShow) {
        [self hideMenuViewController];
    } else {
        [self presentRightMenuViewController];
    }
}

#pragma mark - RESide menu delegate

- (void)sideMenu:(RESideMenu*)sideMenu didShowMenuViewController:(UIViewController*)menuViewController
{
    isShow = YES;
}

- (void)sideMenu:(RESideMenu*)sideMenu didHideMenuViewController:(UIViewController*)menuViewController
{
    isShow = NO;
}

@end
