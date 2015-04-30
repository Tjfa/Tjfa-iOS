//
//  TSMessage+NavigationBar.h
//  Tjfa
//
//  Created by 邱峰 on 4/30/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import "TSMessage.h"

@interface TSMessage (NavigationBar)

+ (void)showNotificationOverNavigatonBarWithTitle:(NSString *)title subtitle:(NSString *)subtitle type:(TSMessageNotificationType)type duration:(NSTimeInterval)duration;


@end
