//
//  RootViewController.h
//  Tjfa
//
//  Created by 邱峰 on 7/16/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RESideMenu.h>
#import "Competition.h"

@interface TJRootViewController : RESideMenu


/**
 *  任意给下面两个参数中的一个即可
 */
@property (nonatomic, strong) NSNumber *compeitionId;
@property (nonatomic, strong) Competition *competition;

@end
