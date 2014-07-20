//
//  MatchViewController.m
//  Tjfa
//
//  Created by 邱峰 on 7/16/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "MatchViewController.h"
#import <RESideMenu.h>
#import "MatchManager.h"
#import "RootViewController.h"
#import "MatchTableViewCell.h"
#import "MBProgressHUD+AppProgressView.h"
#import "UIAlertView+NetWorkErrorView.h"
#import "MJRefresh.h"

@interface MatchViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, MJRefreshBaseViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView* tableView;

@property (nonatomic, weak) IBOutlet UISearchBar* searchBar;

@property (nonatomic, strong) NSArray* data;

@property (nonatomic, strong) MBProgressHUD* mbProgressHud;

@end

@implementation MatchViewController {
    MJRefreshHeaderView* header;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    header = [[MJRefreshHeaderView alloc] init];
    header.delegate = self;
    header.scrollView = self.tableView;

    // Do any additional setup after loading the view.
    //[self.sideMenuViewController presentLeftMenuViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter & setter

- (MBProgressHUD*)mbProgressHud
{
    if (_mbProgressHud == nil) {
        _mbProgressHud = [MBProgressHUD progressHUDNetworkLoadingInView:self.view];
        [self.view addSubview:_mbProgressHud];
    }
    return _mbProgressHud;
}

- (void)getLasterData:(BOOL)isFirstEnter
{
    __weak RootViewController* rootViewController = (RootViewController*)self.sideMenuViewController;
    __weak MatchViewController* weakSelf = self;

    if (isFirstEnter) {
        [self.mbProgressHud show:YES];
    }

    [[MatchManager sharedMatchManager] getMatchesByCompetitionFromNetwork:rootViewController.competition complete:^(NSArray* array, NSError* error) {
        if (error){
            [[UIAlertView alertViewWithErrorNetWork] show];
        }
        else{
            weakSelf.data=array;
            [weakSelf.tableView reloadData];
        }
        
        if (isFirstEnter) {
            [self.mbProgressHud removeFromSuperview];
        }
        [header endRefreshing];

        /**
         *  search bar 交出firstresponder  防止出现搜索后 然后下拉刷新 searchbar没有清空的情况
         */
        self.searchBar.text=@"";
        [self.searchBar resignFirstResponder];
    }];
}

- (NSArray*)data
{
    if (_data == nil) {
        __weak RootViewController* rootViewController = (RootViewController*)self.sideMenuViewController;
        _data = [[MatchManager sharedMatchManager] getMatchesByCompetitionFromCoreData:rootViewController.competition];
        [self getLasterData:YES];
    }
    return _data;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (NSInteger)tableView:(UITableView*)tableView sectionForSectionIndexTitle:(NSString*)title atIndex:(NSInteger)index
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* cellIdentifier = @"MatchTableViewCell";

    MatchTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[MatchTableViewCell alloc] init];
    }
    [cell setCellWithMatch:self.data[indexPath.row]];
    return cell;
}

#pragma mark - search bar

- (void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)searchText
{

    NSString* text = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    __weak RootViewController* rootViewController = (RootViewController*)self.sideMenuViewController;
    if (text == nil || [text isEqualToString:@""]) {
        self.data = [[MatchManager sharedMatchManager] getMatchesByCompetitionFromCoreData:rootViewController.competition];
        [self.tableView reloadData];

    } else {
        self.data = [[MatchManager sharedMatchManager] getMatchesByTeamName:text competition:rootViewController.competition];
        [self.tableView reloadData];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar*)searchBar
{
    [self.searchBar resignFirstResponder];
}

#pragma mark - mjrefresh

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView*)refreshView
{
    [self getLasterData:NO];
}

#pragma mark - scroll
- (void)scrollViewWillBeginDragging:(UIScrollView*)scrollView
{
    [self.searchBar resignFirstResponder];
}

@end
