//
//  MatchManager.h
//  Tjfa
//
//  Created by 邱峰 on 14-3-30.
//  Copyright (c) 2014年 邱峰. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Competition.h"
#import "Match.h"

@interface MatchManager : NSObject

+(MatchManager*) sharedMatchManager;

-(NSArray*) getMatchesByCompetition:(Competition*)competition;

@end
