//
//  MemberListCell.h
//  Tjfa
//
//  Created by 邱峰 on 4/1/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TJUser;

@interface TJMemberListCell : UITableViewCell

- (void)setCellWithUser:(TJUser *)user;

- (void)setCellWithUser:(TJUser *)user andSearchKey:(NSString *)key;

- (void)showAnimate;

@end
