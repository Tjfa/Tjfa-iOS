//
//  AVMatch.h
//  Tjfa
//
//  Created by 邱峰 on 9/22/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@interface AVMatch : AVObject

/**
 *  比赛日期
 */
@property (nonatomic, retain) NSDate* date;

/**
 *  matchId
 */
@property (nonatomic, retain) NSNumber* matchId;

/**
 *  这场比赛是否已经开始   0表示 没有开始  1或者2表示结束
 */
@property (nonatomic, retain) NSNumber* isStart;

/**
 *  比赛性质 0:小组赛  1:决赛 2:半决赛 4:1/4 8:1/8 16:1/16 32:1/32 100：附加赛
 */
@property (nonatomic, retain) NSNumber* matchProperty;

/**
 *  比分 第一只球队的得分
 */
@property (nonatomic, retain) NSNumber* scoreA;

/**
 *  比分 第二只球队的得分
 */
@property (nonatomic, retain) NSNumber* scoreB;

/**
 *  获胜队伍的编号
 */
@property (nonatomic, retain) NSNumber* winTeamId;

/**
 *  点球大战 a队得分
 */
@property (nonatomic, retain) NSNumber* penaltyA;

/**
 *  点球大战b队得分
 */
@property (nonatomic, retain) NSNumber* penaltyB;

/**
 *  所属的赛事
 */
@property (nonatomic, retain) NSNumber* competitionId;

/**
 *  参加这场比赛的2只球队
 */
@property (nonatomic, retain) NSNumber* teamAId;

@property (nonatomic, retain) NSNumber* teamBId;

@end
