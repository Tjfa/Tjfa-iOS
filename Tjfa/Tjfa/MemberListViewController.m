//
//  MemberListViewController.m
//  Tjfa
//
//  Created by 邱峰 on 4/1/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import "MemberListViewController.h"
#import "TJModule.h"
#import <SVPullToRefresh.h>
#import "MemberListCell.h"
#import "SingleChatViewController.h"

@interface MemberListViewController()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *data;

@end

@implementation MemberListViewController

- (void)viewDidLoad
{
 
    __weak typeof(self) weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^() {
        AVQuery *query = [TJUser query];
        [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            [self.tableView.pullToRefreshView stopAnimating];
            if (error) {
                NSLog(@"%@", error.description);
            }
            else {
                weakSelf.data = array;
                [weakSelf.tableView reloadData];
            }

        }];

    }];
    
}

#pragma mark - getter & setter

- (NSArray *)data
{
    if (_data == nil) {
        _data = [NSArray array];
    }
    return _data;
}

#pragma mark - TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MemberListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MemberListCell.class)];
    TJUser *user = self.data[indexPath.row];
    cell.textLabel.text = user.name;
    return cell;
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[MemberListCell class]]) {
        SingleChatViewController *chatViewController = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        TJUser *targetUser = self.data[indexPath.row];
        chatViewController.targetUser = targetUser;
    }
}

@end
