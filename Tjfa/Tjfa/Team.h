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
 *  进球数(小组赛) 过了小组赛 不在统计
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
 *  所属赛事 方便统计某个赛事的参加球队
 */
@property (nonatomic, retain) Competition* competition;

/**
 *  所属比赛
 */
@property (nonatomic, retain) Match* match;

/**
 *  该队伍的队员
 */
@property (nonatomic, retain) NSSet* players;

@end

@interface Team (CoreDataGeneratedAccessors)

- (void)addMatchObject:(Match*)value;
- (void)removeMatchObject:(Match*)value;
- (void)addMatch:(NSSet*)values;
- (void)removeMatch:(NSSet*)values;

- (void)addPlayersObject:(Player*)value;
- (void)removePlayersObject:(Player*)value;
- (void)addPlayers:(NSSet*)values;
- (void)removePlayers:(NSSet*)values;

/**
 *  不更新player
 *
 *  @param dictionary  dictionary of team
 *  @param competition comptetion
 *  @param match       match
 *
 *  @return 更新或者创建后的team
 */
+ (Team*)updateBasePropertyWithDictionary:(NSDictionary*)dictionary competition:(Competition*)competition andMatch:(Match*)match;

+ (NSString*)idAttribute;

@end
