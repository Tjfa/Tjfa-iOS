//
//  AVCompetition.h
//  Tjfa
//
//  Created by 邱峰 on 9/22/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@interface TJCompetition : AVObject <AVSubclassing>

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

/**x
 *  赛事时间 20131与20132表示第一学期和第二学期
 */
@property (nonatomic, retain) NSString *time;

@end
