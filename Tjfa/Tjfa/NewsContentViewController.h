//
//  NewsContentViewController.h
//  Tjfa
//
//  Created by 邱峰 on 7/8/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"
#import "News.h"

@interface NewsContentViewController : BaseViewController

@property (nonatomic, strong) News *news;
@property (nonatomic, strong) NSNumber *newsId;

@end
