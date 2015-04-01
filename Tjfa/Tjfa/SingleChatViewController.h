//
//  SingleChatViewController.h
//  Tjfa
//
//  Created by 邱峰 on 3/31/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import "ChatViewController.h"

@class TJUser;

@interface SingleChatViewController : ChatViewController

@property (nonatomic, strong) TJUser *targetUser;

@end
