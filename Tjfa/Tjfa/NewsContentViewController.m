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
    UIImageView* bg = [[UIImageView alloc] initWithFrame:self.view.frame];
    [bg setImage:[UIImage imageNamed:@"newsContent"]];
    [self.view addSubview:bg];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.contentView setOpaque:NO];
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
    [self.contentView loadHTMLString:self.news.content baseURL:nil];
    //    [self.progressView show:YES];
    //    __weak NewsContentViewController* weakSelf = self;
    //    [[NewsManager sharedNewsManager] getNewsContentWithNews:self.news complete:^(News* news, NSError* error) {
    //            [weakSelf.progressView removeFromSuperview];
    //            if (error){
    //                [MBProgressHUD showWhenNetworkErrorInView:weakSelf.view];
    //            }
    //            else{
    //                [self.contentView loadHTMLString:news.content baseURL:nil];
    //            }
    //    }];
}

@end
