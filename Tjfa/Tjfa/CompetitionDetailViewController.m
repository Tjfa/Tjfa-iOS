//
//  CompetitionDetailViewController.m
//  Tjfa
//
//  Created by 邱峰 on 7/21/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "CompetitionDetailViewController.h"
#import "RootViewController.h"
#import "UIAlertView+NetWorkErrorView.h"
#import "MBProgressHUD+AppProgressView.h"

@interface CompetitionDetailViewController ()

@property (nonatomic, strong) MBProgressHUD* mbProgressHud;

@property (nonatomic, strong) MJRefreshHeaderView* header;

@end

@implementation CompetitionDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.header.scrollView = self.tableView;
    // Do any additional setup after loading the view.
}

- (void)getLasterData:(BOOL)isFirstEnter
{
    __weak RootViewController* rootViewController = (RootViewController*)self.sideMenuViewController;

    if (isFirstEnter) {
        [self.mbProgressHud show:YES];
    }

    [self getDataFromNetwork:rootViewController.competition complete:self.completeBlock];
}

#pragma mark - getter & setter

- (void (^)(NSArray* array, NSError* error))completeBlock
{
    if (_completeBlock == nil) {
        __weak CompetitionDetailViewController* weakSelf = self;
        _completeBlock = ^(NSArray* array, NSError* error) {
            if (error) {
                [[UIAlertView alertViewWithErrorNetWork] show];
            } else {
                weakSelf.data = array;
                [weakSelf.tableView reloadData];
            }
            
            [weakSelf.mbProgressHud removeFromSuperview];

            [weakSelf.header endRefreshing];
            
            /**
             *  search bar 交出firstresponder  防止出现搜索后 然后下拉刷新 searchbar没有清空的情况
             */
            weakSelf.searchBar.text = @"";
            [weakSelf.searchBar resignFirstResponder];
        };
    }
    return _completeBlock;
}

- (NSArray*)data
{
    __weak RootViewController* rootViewController = (RootViewController*)self.sideMenuViewController;
    if (_data == nil) {
        _data = [self getDataFromCoreDataCompetition:rootViewController.competition];
        if (_data == nil || _data.count == 0) {
            [self getLasterData:YES];
        }
    }
    return _data;
}

- (MJRefreshHeaderView*)header
{
    if (_header == nil) {
        _header = [[MJRefreshHeaderView alloc] init];
        self.header.delegate = self;
    }
    return _header;
}

- (MBProgressHUD*)mbProgressHud
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
        _searchBar.backgroundColor=[UIColor appRedColor];
        _searchBar.barTintColor=[UIColor appRedColor];
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

#pragma mark - mjrefresh

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView*)refreshView
{
    [self getLasterData:NO];
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

#pragma mark - delloc

- (void)dealloc
{
    [self.header free];
}

@end
