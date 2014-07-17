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
#import "MatchTableViewCell.h"

@interface MatchViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView* tableView;

@property (nonatomic, strong) NSArray* data;

@end

@implementation MatchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self.sideMenuViewController presentLeftMenuViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter & setter

- (NSArray*)data
{
    if (_data == nil) {
        _data = [[MatchManager sharedMatchManager] getMatchesByCompetitionFromCoreData:self.competition];
        NSLog(@"%@",self.competition);
        __weak MatchViewController* weakSelf = self;
        [[MatchManager sharedMatchManager] getMatchesByCompetitionFromNetwork:self.competition complete:^(NSArray* array, NSError* error) {
            if (error){
                
            }
            else{
                weakSelf.data=array;
                [weakSelf.tableView reloadData];
            }
        }];
    }
    return _data;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView sectionForSectionIndexTitle:(NSString*)title atIndex:(NSInteger)index
{
    return self.data.count;
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

@end
