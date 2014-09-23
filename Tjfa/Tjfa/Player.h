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
@class AVPlayer;

@interface Player : NSManagedObject

/**
 *  进球数
 */
@property (nonatomic, retain) NSNumber* goalCount;

/**
 *  playerId  主键
 */
@property (nonatomic, retain) NSNumber* playerId;

/**
 *  名字
 */
@property (nonatomic, retain) NSString* name;

/**
 *  红牌数量
 */
@property (nonatomic, retain) NSNumber* redCard;

/**
 *  黄牌数量
 */
@property (nonatomic, retain) NSNumber* yellowCard;

/**
 *  所属于的球队
 */
@property (nonatomic, retain) Team* team;

/**
 *  所属比赛
 */
@property (nonatomic, retain) Competition* competition;

+ (NSString*)idAttributeStr;

+ (NSString*)redCardAttributeStr;

+ (NSString*)yellowCardAttributeStr;

+ (NSString*)goalCountAttributeStr;

+ (Player*)updatePlayerWithDictionary:(AVPlayer*)player competition:(Competition*)competition;

@end
