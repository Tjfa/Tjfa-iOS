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

@property (nonatomic, retain) NSNumber * competitionID;
@property (nonatomic, retain) NSNumber * isStart;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) NSSet *matches;
@property (nonatomic, retain) NSSet *teams;
@property (nonatomic, retain) NSSet *players;
@end

@interface Competition (CoreDataGeneratedAccessors)

- (void)addMatchesObject:(Match *)value;
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
