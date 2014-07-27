//
//  Match.h
//  Tjfa
//
//  Created by 邱峰 on 14-3-25.
//  Copyright (c) 2014年 邱峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Competition, Team;

@interface Match : NSManagedObject

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
@property (nonatomic, retain) Competition* competition;

/**
 *  参加这场比赛的2只球队
 */
@property (nonatomic, retain) Team* teamA;

@property (nonatomic, retain) Team* teamB;

/**
 *   更新matches，同时更新team的基本属性
 *
 *  @param dictionary  包含match的基本属性 以及 teams
 *  @param competition 所属于的competition
 */
+ (Match*)updateMatchWithDictionary:(NSDictionary*)dictionary andCompetetion:(Competition*)competition;

+ (NSString*)idAttribute;

@end
