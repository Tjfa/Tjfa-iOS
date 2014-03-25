//
//  Competition.h
//  Tjfa
//
//  Created by 邱峰 on 14-3-25.
//  Copyright (c) 2014年 邱峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Match, Team;

@interface Competition : NSManagedObject

@property (nonatomic, retain) NSNumber * competitionID;     //赛事ID
@property (nonatomic, retain) NSNumber * isStart;           //这个赛事是否开始
@property (nonatomic, retain) NSString * name;              //赛事名称
@property (nonatomic, retain) NSNumber * number;            //第几届赛事
@property (nonatomic, retain) NSDate * time;                //赛事时间 只要个大概 如 2013年1月
@property (nonatomic, retain) NSSet *matches;               //所有比赛
@property (nonatomic, retain) NSSet *teams;                 //参赛球队

+(NSString*) IdAttributeStr;

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

@end
