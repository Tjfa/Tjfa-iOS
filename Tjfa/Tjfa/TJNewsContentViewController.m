//
//  NewsContentViewController.m
//  Tjfa
//
//  Created by 邱峰 on 7/8/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "TJNewsContentViewController.h"
#import "TJNewsManager.h"
#import <MBProgressHUD.h>
#import "MBProgressHUD+AppProgressView.h"

@interface TJNewsContentViewController ()

@property (nonatomic, weak) IBOutlet UIWebView *contentView;

@property (nonatomic, weak) MBProgressHUD *progressView;

@end

@implementation TJNewsContentViewController

+ (id)allocWithRouterParams:(NSDictionary *)params
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TJNewsContentViewController *instance = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
    instance.newsId = params[@"newsId"];
    return instance;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadContent];
}

#pragma mark - load content

- (void)loadContent
{
    if (self.news) {
        [self.contentView loadHTMLString:self.news.content baseURL:nil];
        self.navigationItem.title = self.news.title;
    }
    else {
        self.navigationItem.title = @"加载中";
        self.progressView = [MBProgressHUD progressHUDNetworkLoadingInView:nil withText:nil];
        [[TJNewsManager sharedNewsManager] getNewsWithNewsId:self.newsId complete:^(News *news, NSError *error) {
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
}

@end
