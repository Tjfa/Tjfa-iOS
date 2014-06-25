//
//  Competition.h
//  Tjfa
//
//  Created by 邱峰 on 14-3-30.
//  Copyright (c) 2014年 邱峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Match, Player, Team;

@interface Competition : NSManagedObject

@property (nonatomic, retain) NSNumber* competitionID; //赛事ID
@property (nonatomic, retain) NSNumber* isStart; //这个赛事是否开始
@property (nonatomic, retain) NSString* name; //赛事名称
@property (nonatomic, retain) NSNumber* number; //第几届赛事
@property (nonatomic, retain) NSString* time; //赛事时间 20131与20132表示第一学期和第二学期
@property (nonatomic, retain) NSSet* matches; //所有比赛
@property (nonatomic, retain) NSSet* teams; //参赛球队
@property (nonatomic, retain) NSSet* players; //参赛球员

+ (NSString*)idAttributeStr;

+ (NSString*)timeAttributeStr;

+ (NSString*)nameAttributeStr;

@end

@interface Competition (CoreDataGeneratedAccessors)

- (void)addMatchesObject:(Match*)value;
- (void)removeMatchesObject:(Match*)value;
- (void)addMatches:(NSSet*)values;
- (void)removeMatches:(NSSet*)values;

- (void)addTeamsObject:(Team*)value;
- (void)removeTeamsObject:(Team*)value;
- (void)addTeams:(NSSet*)values;
- (void)removeTeams:(NSSet*)values;

- (void)addPlayersObject:(Player*)value;
- (void)removePlayersObject:(Player*)value;
- (void)addPlayers:(NSSet*)values;
- (void)removePlayers:(NSSet*)values;

@end
