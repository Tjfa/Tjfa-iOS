//
//  NewsContentViewController.m
//  Tjfa
//
//  Created by 邱峰 on 7/8/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "NewsContentViewController.h"
#import "NewsManager.h"
#import <MBProgressHUD.h>
#import "MBProgressHUD+AppProgressView.h"
#import "UIAlertView+NetWorkErrorView.h"

@interface NewsContentViewController ()

@property (nonatomic, weak) IBOutlet UIWebView* contentView;

@property (nonatomic, strong) MBProgressHUD* loadProgress;

@end

@implementation NewsContentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = self.news.title;

    [self.loadProgress show:YES];
    [self loadContent];
}

#pragma mark - getter & setter

- (MBProgressHUD*)loadProgress
{
    if (_loadProgress == nil) {
        self.loadProgress = [MBProgressHUD progressHUDNetworkLoadingInView:self.view];
        [self.view addSubview:_loadProgress];
    }
    return _loadProgress;
}

#pragma mark - load content

- (void)loadContent
{
    __weak NewsContentViewController* weakSelf = self;
    [[NewsManager sharedNewsManager] getNewsContentWithNews:self.news complete:^(News* news, NSError* error) {

        [weakSelf.loadProgress removeFromSuperview];

        if (error){
        }
        else{
            [weakSelf.contentView loadHTMLString:news.content baseURL:nil];
        }
    }];
}

@end
