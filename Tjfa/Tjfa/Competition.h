//
//  Competition.h
//  Tjfa
//
//  Created by 邱峰 on 14-3-30.
//  Copyright (c) 2014年 邱峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

/**
 *  这里给xcode6跪了 只要import 就编译失败 解决方法就是用了 class forward declare
 */

@class Match, Player, Team;
@class TJCompetition;

@interface Competition : NSManagedObject

/**
 *  competitionId
 */
@property (nonatomic, retain) NSNumber *competitionId;

/**
 *  1 表示本部 2表示 嘉定
 */
@property (nonatomic, retain) NSNumber *type;

/**
 *  这个赛事是否开始 0 未开始 1正在进行 2已经结束
 */
@property (nonatomic, retain) NSNumber *isStart;

/**
 *  赛事名称
 */
@property (nonatomic, retain) NSString *name;

/**
 *  第几届赛事
 */
@property (nonatomic, retain) NSNumber *number;

/**
 *  赛事时间 20131与20132表示第一学期和第二学期
 */
@property (nonatomic, retain) NSString *time;

/**
 *  所有比赛
 */
@property (nonatomic, retain) NSSet *matches;

/**
 *  参赛球队
 */
@property (nonatomic, retain) NSSet *teams;

/**
 *  参赛球员
 */
@property (nonatomic, retain) NSSet *players;

+ (NSString *)idAttributeStr;

+ (NSString *)timeAttributeStr;

+ (NSString *)nameAttributeStr;

+ (NSString *)typeAttributeStr;

+ (Competition *)updateBasePropertyWithDictionary:(TJCompetition *)avCompetition;

@end

@interface Competition (CoreDataGeneratedAccessors)

-
    (void)addMatchesObject:(Match *)value;
- (void)removeMatchesObject:(Match *)value;
- (void)addMatches:(NSSet *)values;
- (void)removeMatches:(NSSet *)values;

- (void)addTeamsObject:(Team *)value;
- (void)removeTeamsObject:(Team *)value;
- (void)addTeams:(NSSet *)values;
- (void)removeTeams:(NSSet *)values;

- (void)addPlayersObject:(Player *)value;
- (void)removePlayersObject:(Player *)value;
- (void)addPlayers:(NSSet *)values;
- (void)removePlayers:(NSSet *)values;

@end
