//
//  WelcomeViewController.m
//  Tjfa
//
//  Created by 邱峰 on 7/10/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "TJWelcomeViewController.h"
#import "TJUserData.h"
#import "TJWelcome3.h"
#import "TJWelcome1.h"
#import "TJWelcome2.h"
#import "UIApplication+MainNav.h"

@interface TJWelcomeViewController () <UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end

@implementation TJWelcomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    if ([TJUserData sharedUserData].isFirstLaunch) {

        CGSize screenSize = self.view.frame.size;
        TJWelcome3 *welcome3 = [TJWelcome3 getInstance];
        welcome3.rootView = self.scrollView;

        welcome3.frame = CGRectMake(screenSize.width * 2, 0, welcome3.frame.size.width, welcome3.frame.size.height);
        self.scrollView.contentSize = CGSizeMake(screenSize.width * 3, screenSize.height);

        TJWelcome1 *welcome1 = [TJWelcome1 getInstance];
        [self.scrollView addSubview:welcome1];

        TJWelcome2 *welcome2 = [TJWelcome2 getInstance];
        welcome2.frame = CGRectMake(screenSize.width, 0, welcome2.frame.size.width, welcome2.frame.size.height);
        [self.scrollView addSubview:welcome2];

        [self.scrollView addSubview:welcome3];
    }
    else {
        [UIApplication showMain];
    }
    // Do any additional setup after loading the view.
}

- (void)setScrollView:(UIScrollView *)scrollView
{
    if (_scrollView != scrollView) {
        _scrollView = scrollView;
        _scrollView.delegate = self;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.scrollView.contentOffset.x < 100) {
        self.pageControl.currentPage = 0;
    }
    else if (self.scrollView.contentOffset.x > 300 && self.scrollView.contentOffset.x < 350) {
        self.pageControl.currentPage = 1;
    }
    else {
        self.pageControl.currentPage = 2;
    }
}

@end
