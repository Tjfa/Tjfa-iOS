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

@interface NewsContentViewController ()

@property (nonatomic, weak) IBOutlet UIWebView* contentView;

@property (nonatomic, weak) MBProgressHUD* progressView;

@end

@implementation NewsContentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = self.news.title;

    [self loadContent];
}

- (MBProgressHUD*)progressView
{
    if (_progressView == nil) {
        _progressView = [MBProgressHUD progressHUDNetworkLoadingInView:self.view];
        [self.view addSubview:_progressView];
    }
    return _progressView;
}

#pragma mark - load content

- (void)loadContent
{
    if (self.news.content && ![self.news.content isEqualToString:@""]) {
        [self.contentView loadHTMLString:self.news.content baseURL:nil];
    } else {
        [self.progressView show:YES];
        __weak NewsContentViewController* weakSelf = self;
        [[NewsManager sharedNewsManager] getNewsContentWithNews:self.news complete:^(News* news, NSError* error) {
            [weakSelf.contentView removeFromSuperview];
            if (error){
                [MBProgressHUD showWhenNetworkErrorInView:weakSelf.view];
            }
            else{
                [self.contentView loadHTMLString:news.content baseURL:nil];
            }
        }];
    }
}

@end
