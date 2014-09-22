//
//  AVTeam.h
//  Tjfa
//
//  Created by 邱峰 on 9/22/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@interface AVTeam : AVObject

/**
 *  队徽地址
 */
@property (nonatomic, retain) NSString* emblemPath;

/**
 *  小组赛进球数
 */
@property (nonatomic, retain) NSNumber* groupGoalCount;

/**
 *  小组赛失球数
 */
@property (nonatomic, retain) NSNumber* groupMissCount;

/**
 *  进球数
 */
@property (nonatomic, retain) NSNumber* goalCount;

/**
 *  所在小组 A B C D
 */
@property (nonatomic, retain) NSString* groupNo;

/**
 *  teamId
 */
@property (nonatomic, retain) NSNumber* teamId;

/**
 *  失球数
 */
@property (nonatomic, retain) NSNumber* missCount;

/**
 *  小组赛获胜场次
 */
@property (nonatomic, retain) NSNumber* groupWinCount;

/**
 *  小组赛平局场次
 */
@property (nonatomic, retain) NSNumber* groupDrawCount;

/**
 *  小组赛失利场次
 */
@property (nonatomic, retain) NSNumber* groupLostCount;

/**
 *  总共获胜场次
 */
@property (nonatomic, retain) NSNumber* winCount;

/**
 *  总共失利场次
 */
@property (nonatomic, retain) NSNumber* lostCount;

/**
 *  队伍名字
 */
@property (nonatomic, retain) NSString* name;

/**
 *  小组赛积分
 */
@property (nonatomic, retain) NSNumber* score;

/**
 *  最高排名  1234 前4名   8 八强  16 16强 0小组赛 100附加赛
 */
@property (nonatomic, retain) NSNumber* rank;

/**
 *  所属赛事 方便统计某个赛事的参加球队
 */
@property (nonatomic, retain) NSNumber* competitionId;

/**
 *  该队伍的队员
 */
@property (nonatomic, retain) NSSet* players;

@end
