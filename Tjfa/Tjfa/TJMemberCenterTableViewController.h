//
//  TJMemberCenterTableViewController.h
//  Tjfa
//
//  Created by 邱峰 on 4/7/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import "TJBaseTableViewController.h"
#import "TJUser.h"

@interface TJMemberCenterTableViewController : TJBaseTableViewController

/**
 *  这两个信息只需要一个即可
 */
@property (nonatomic, strong) TJUser *targerUser;
@property (nonatomic, strong) NSString *userAccount;

@end
