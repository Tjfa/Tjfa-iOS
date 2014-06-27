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
 *  这场比赛是否已经开始
 */
@property (nonatomic, retain) NSNumber* isStart;

/**
 *  比赛性质 0 小组赛  1 淘汰赛
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
 *  获胜队伍的编号 由于这边是set 所以只有这个办法
 */
@property (nonatomic, retain) NSNumber* winTeamId;

/**
 *  所属的赛事
 */
@property (nonatomic, retain) Competition* competition;

/**
 *  参加这场比赛的2只球队
 */
@property (nonatomic, retain) NSSet* teams;
@end

@interface Match (CoreDataGeneratedAccessors)

- (void)addTeamsObject:(Team*)value;
- (void)removeTeamsObject:(Team*)value;
- (void)addTeams:(NSSet*)values;
- (void)removeTeams:(NSSet*)values;

@end
