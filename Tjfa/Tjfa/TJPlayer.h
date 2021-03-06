//
//  AVPlayer.h
//  Tjfa
//
//  Created by 邱峰 on 9/22/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@interface TJPlayer : AVObject <AVSubclassing>

/**
 *  进球数
 */
@property (nonatomic, retain) NSNumber *goalCount;

/**
 *  playerId  主键
 */
@property (nonatomic, retain) NSNumber *playerId;

/**
 *  名字
 */
@property (nonatomic, retain) NSString *name;

/**
 *  红牌数量
 */
@property (nonatomic, retain) NSNumber *redCard;

/**
 *  黄牌数量
 */
@property (nonatomic, retain) NSNumber *yellowCard;

/**
 *  所属于的球队
 */
@property (nonatomic, retain) NSNumber *teamId;

/**
 *  所属比赛
 */
@property (nonatomic, retain) NSNumber *competitionId;

@end
