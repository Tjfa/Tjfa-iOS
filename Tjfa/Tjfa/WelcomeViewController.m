//
//  WelcomeViewController.m
//  Tjfa
//
//  Created by 邱峰 on 7/10/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "WelcomeViewController.h"
#import "UserData.h"
#import "Welcome3.h"
#import "UIApplication+MainNav.h"

@interface WelcomeViewController ()

@property (nonatomic, weak) IBOutlet UIScrollView* scrollView;

@end

@implementation WelcomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    if ([UserData sharedUserData].isFirstLaunch) {
        Welcome3* welcome3 = [Welcome3 getInstance];
        welcome3.rootView=self.scrollView;
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        self.scrollView.contentSize = CGSizeMake(screenSize.width * 4, screenSize.height);
        
        [self.scrollView addSubview:welcome3];

    } else {
        [UIApplication showMain];
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
