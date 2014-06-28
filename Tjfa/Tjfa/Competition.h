//
//  Competition.h
//  Tjfa
//
//  Created by 邱峰 on 6/28/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Match, Player, Team;

@interface Competition : NSManagedObject

@property (nonatomic, retain) NSNumber* competitionId;
@property (nonatomic, retain) NSNumber* isStart;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSNumber* number;
@property (nonatomic, retain) NSString* time;
@property (nonatomic, retain) NSNumber* type;
@property (nonatomic, retain) NSSet* matches;
@property (nonatomic, retain) NSSet* players;
@property (nonatomic, retain) NSSet* teams;
@end

@interface Competition (CoreDataGeneratedAccessors)

+ (NSString*)idAttributeStr;

+ (NSString*)timeAttributeStr;

+ (NSString*)nameAttributeStr;

+ (NSString*)typeAttributeStr;

- (void)addMatchesObject:(Match*)value;
- (void)removeMatchesObject:(Match*)value;
- (void)addMatches:(NSSet*)values;
- (void)removeMatches:(NSSet*)values;

- (void)addPlayersObject:(Player*)value;
- (void)removePlayersObject:(Player*)value;
- (void)addPlayers:(NSSet*)values;
- (void)removePlayers:(NSSet*)values;

- (void)addTeamsObject:(Team*)value;
- (void)removeTeamsObject:(Team*)value;
- (void)addTeams:(NSSet*)values;
- (void)removeTeams:(NSSet*)values;

+ (Competition*)updateBasePropertyWithDictionary:(NSDictionary*)dictionary;

@end
