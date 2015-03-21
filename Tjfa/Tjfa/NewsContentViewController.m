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

+ (id)allocWithRouterParams:(NSDictionary *)params
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NewsContentViewController *instance = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
    instance.newsId = params[@"newsId"];
    return instance;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
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
    if (self.news) {
        [self.contentView loadHTMLString:self.news.content baseURL:nil];
        self.navigationItem.title = self.news.title;

    } else {
        self.navigationItem.title = @"加载中";
        [self.progressView show:YES];
        [[NewsManager sharedNewsManager] getNewsWithNewsId:self.newsId complete:^(News *news, NSError *error) {
            [self.progressView hide:YES];
            if (error) {
                [MBProgressHUD showWhenNetworkErrorInView:self.view];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                self.news = news;
                [self.contentView loadHTMLString:self.news.content baseURL:nil];
                self.navigationItem.title = self.news.title;
            }
        }];

    }
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
