//
//  MatchListViewController.h
//  Tjfa
//
//  Created by JackYu on 6/29/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

@interface MatchListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, MJRefreshBaseViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
