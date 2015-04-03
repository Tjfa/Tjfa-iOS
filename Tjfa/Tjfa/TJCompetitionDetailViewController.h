//
//  CompetitionDetailViewController.h
//  Tjfa
//
//  Created by 邱峰 on 7/21/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD+AppProgressView.h"
#import <MBProgressHUD.h>
#import "Competition.h"
#import "TJBaseViewController.h"

@interface TJCompetitionDetailViewController : TJBaseViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIGestureRecognizerDelegate> {
}

@property (nonatomic, weak) IBOutlet UITableView* tableView;

@property (nonatomic, weak) IBOutlet UISearchBar* searchBar;

@property (nonatomic, strong) NSArray* data;

@property (nonatomic, strong) void (^completeBlock)(NSArray* array, NSError* error);

- (void)getLasterData:(BOOL)isFirstEnter;

/**
 *  template method
 */

/**
 *  the follow class need to implement by subclass
 *  the example to see the RedCardViewController
 */
- (NSArray*)getDataFromCoreDataCompetition:(Competition*)compeition;

- (NSArray*)getDataFromCoreDataCompetition:(Competition*)competition whenSearch:(NSString*)key;

- (void)getDataFromNetwork:(Competition*)competition complete:(void (^)(NSArray* results, NSError* error))complete;

@end
