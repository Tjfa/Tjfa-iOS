//
//  TJChatNotificationCell.h
//  Tjfa
//
//  Created by 邱峰 on 4/16/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import "TJBaseNotificationCell.h"

@class EMMessage;

@interface TJChatNotificationCell : TJBaseNotificationCell

- (void)setCellWithEMMessage:(EMMessage *)emMessage;

@end
