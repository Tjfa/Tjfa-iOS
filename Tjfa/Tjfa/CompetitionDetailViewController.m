//
//  CompetitionDetailViewController.m
//  Tjfa
//
//  Created by 邱峰 on 7/21/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "CompetitionDetailViewController.h"
#import "RootViewController.h"
#import "MBProgressHUD+AppProgressView.h"
#import "UIColor+AppColor.h"
#import <SVPullToRefresh.h>

@interface CompetitionDetailViewController ()

@property (nonatomic, strong) MBProgressHUD* mbProgressHud;


@end

@implementation CompetitionDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView addPullToRefreshWithActionHandler:^() {
        [self getLasterData:NO];
    }];

    
    if (self.data == nil || self.data.count == 0) {
        self.data = [[NSArray alloc] init];
        [self getLasterData:YES];
    }
    else {
        [self.tableView triggerPullToRefresh];
    }
    
    

    // Do any additional setup after loading the view.
}

- (void)getLasterData:(BOOL)isFirstEnter
{
    __weak RootViewController *rootViewController = (RootViewController *)self.sideMenuViewController;
    if (isFirstEnter) {
        [self.mbProgressHud show:YES];
    }
    [self getDataFromNetwork:rootViewController.competition complete:self.completeBlock];
}

#pragma mark - getter & setter

- (void (^)(NSArray *array, NSError *error))completeBlock
{
    if (_completeBlock == nil) {
        __weak CompetitionDetailViewController* weakSelf = self;
        _completeBlock = ^(NSArray* array, NSError* error) {
            if (error && weakSelf) {
                [MBProgressHUD showWhenNetworkErrorInView:weakSelf.view];
            } else {
                weakSelf.data = array;
                [weakSelf.tableView reloadData];
            }
            
            [weakSelf.mbProgressHud removeFromSuperview];

            [weakSelf.tableView.pullToRefreshView stopAnimating];
            
            /**
             *  search bar 交出firstresponder  防止出现搜索后 然后下拉刷新 searchbar没有清空的情况
             */
            weakSelf.searchBar.text = @"";
            [weakSelf.searchBar resignFirstResponder];
        };
    }
    return _completeBlock;
}

- (NSArray *)data
{
    if (_data == nil) {
        __weak RootViewController *rootViewController = (RootViewController *)self.sideMenuViewController;
        _data = [self getDataFromCoreDataCompetition:rootViewController.competition];
    }
    return _data;
}

- (MBProgressHUD *)mbProgressHud
{
    if (_mbProgressHud == nil) {
        _mbProgressHud = [MBProgressHUD progressHUDNetworkLoadingInView:self.view];
        [self.view addSubview:_mbProgressHud];
    }
    return _mbProgressHud;
}

- (void)setSearchBar:(UISearchBar*)searchBar
{
    if (searchBar != _searchBar) {
        _searchBar = searchBar;
        _searchBar.backgroundColor = [UIColor appRedColor];
        _searchBar.barTintColor = [UIColor appRedColor];
        UITextField* searchField = [_searchBar valueForKey:@"_searchField"];
        searchField.textColor = [UIColor appRedColor];
    }
}

#pragma mark - tableview delegate & datasource

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return [[UITableViewCell alloc] init];
}

#pragma mark - search bar delegate

- (void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)searchText
{
    NSString* text = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    __weak RootViewController* rootViewController = (RootViewController*)self.sideMenuViewController;
    if (text == nil || [text isEqualToString:@""]) {
        self.data = [self getDataFromCoreDataCompetition:rootViewController.competition];
        [self.tableView reloadData];

    } else {
        self.data = [self getDataFromCoreDataCompetition:rootViewController.competition whenSearch:text];
        [self.tableView reloadData];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar*)searchBar
{
    [self.searchBar resignFirstResponder];
}

#pragma mark - scorllview

- (void)scrollViewWillBeginDragging:(UIScrollView*)scrollView
{
    [self.searchBar resignFirstResponder];
}

#pragma mark - @implementation by subclass

- (NSArray*)getDataFromCoreDataCompetition:(Competition*)competition whenSearch:(NSString*)key
{
    return @[];
}

- (NSArray*)getDataFromCoreDataCompetition:(Competition*)compeition
{
    return @[];
}

- (void)getDataFromNetwork:(Competition*)competition complete:(void (^)(NSArray*, NSError*))compete
{
    return;
}

@end
