//
//  RootViewController.m
//  Tjfa
//
//  Created by 邱峰 on 7/16/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "RootViewController.h"
#import "UIViewController+Identifier.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)awakeFromNib
{
    self.menuPreferredStatusBarStyle = UIStatusBarStyleLightContent;
    UIViewController* viewController = [self.storyboard instantiateViewControllerWithIdentifier:[UIViewController matchViewControllerIdentifier]];
    self.contentViewController = viewController;
    self.rightMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:[UIViewController menuViewControllerIdentifier]];
    //    self.rightMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"rightMenuController"];
}

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
