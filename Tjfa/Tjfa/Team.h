//
//  Team.h
//  Tjfa
//
//  Created by 邱峰 on 6/28/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Competition, Match, Player;

@interface Team : NSManagedObject

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
@property (nonatomic, retain) Competition* competition;

/**
 *  该队伍的队员
 */
@property (nonatomic, retain) NSSet* players;

/**
 *  不更新player
 *
 *  @param dictionary  dictionary of team
 *  @param competition comptetion
 *  @param match       match
 *
 *  @return 更新或者创建后的team
 */
+ (Team*)updateTeamWithDictionary:(NSDictionary*)dictionary competition:(Competition*)competition;

+ (NSString*)idAttribute;

@end

@interface Team (CoreDataGeneratedAccessors)

- (void)addPlayersObject:(Player*)value;
- (void)removePlayersObject:(Player*)value;
- (void)addPlayers:(NSSet*)values;
- (void)removePlayers:(NSSet*)values;

@end
