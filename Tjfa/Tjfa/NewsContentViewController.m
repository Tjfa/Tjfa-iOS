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

@end

@implementation NewsContentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = self.news.title;

    [self loadContent];
}

#pragma mark - load content

- (void)loadContent
{
    [self.contentView loadHTMLString:self.news.content baseURL:nil];
}

@end
