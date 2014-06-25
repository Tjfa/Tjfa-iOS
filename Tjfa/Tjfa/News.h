//
//  News.h
//  Tjfa
//
//  Created by 邱峰 on 14-3-25.
//  Copyright (c) 2014年 邱峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface News : NSManagedObject

/**
 *  新闻内容
 */
@property (nonatomic, retain) NSString* content;

/**
 *  日期
 */
@property (nonatomic, retain) NSDate* date;

/**
 *  新闻ID
 */
@property (nonatomic, retain) NSNumber* newsID;

/**
 *  新闻标题
 */
@property (nonatomic, retain) NSString* title;

@end
