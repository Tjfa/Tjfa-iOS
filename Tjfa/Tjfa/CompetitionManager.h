//
//  CompetitionManager.h
//  Tjfa
//
//  Created by 邱峰 on 14-3-25.
//  Copyright (c) 2014年 邱峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Competition.h"

@interface CompetitionManager : NSObject


+(CompetitionManager*) sharedCompetitionManager;


-(Competition*) getCompetitionById:(int)competitionId;


@end
