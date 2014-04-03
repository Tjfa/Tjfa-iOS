//
//  Player.h
//  Tjfa
//
//  Created by 邱峰 on 14-3-25.
//  Copyright (c) 2014年 邱峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Team;
@class Competition;

@interface Player : NSManagedObject

@property (nonatomic, retain) NSNumber * goalCount;     //进球数
@property (nonatomic, retain) NSNumber * playerID;      //playerID  主键
@property (nonatomic, retain) NSString * name;          //名字
@property (nonatomic, retain) NSNumber * redCard;       //红牌数量
@property (nonatomic, retain) NSNumber * yellowCard;    //黄牌数量
@property (nonatomic, retain) Team *team;               //所属于的球队
@property (nonatomic, retain) Competition* competition; //所属比赛

+(NSString*) idAttributeStr;

+(NSString*) redCardAttributeStr;

+(NSString*) yellowCardAttributeStr;

+(NSString*) goalCountAttributeStr;

@end
