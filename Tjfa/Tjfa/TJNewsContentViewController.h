//
//  NewsContentViewController.h
//  Tjfa
//
//  Created by 邱峰 on 7/8/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TJBaseViewController.h"
#import "News.h"

@interface TJNewsContentViewController : TJBaseViewController

@property (nonatomic, strong) News *news;
@property (nonatomic, strong) NSNumber *newsId;

@end
