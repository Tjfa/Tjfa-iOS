//
//  TJMatchDayViewController.h
//  Tjfa
//
//  Created by 邱峰 on 4/18/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import "TJBaseViewController.h"

@class TJMatch;

@interface TJMatchDayViewController : TJBaseViewController

@property (nonatomic, strong) TJMatch *match;
@property (nonatomic, assign) NSString *matchObjectId;
@property (nonatomic, assign) NSNumber *matchId;

@end
