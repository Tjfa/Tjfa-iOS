//
//  News.h
//  Tjfa
//
//  Created by 邱峰 on 6/27/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AVNews;

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
 *  新闻Id
 */
@property (nonatomic, retain) NSNumber* newsId;

/**
 *  新闻标题
 */
@property (nonatomic, retain) NSString* title;

/**
 *  该新闻是否阅读过 只在本地存在
 */
@property (nonatomic, retain) NSNumber* isRead;

/**
 *  预览文字内容 
 */
@property (nonatomic, retain) NSString* precontent;

+ (NSString*)idAttribute;

/**
 *  将后台获取到的news的基本属性更新
 *  根据newsID找对应的数据 如果找不到 会创建一个新的实例 并且保存
 *
 *  @param dictionary 后台获取的json , 由于news的content可能比较大。。。在加上标题党。。。在loadnews的时候 先不传递content了
 *
 *  @return 更新过后的news
 */
+ (News*)updateNewsWithDictionary:(AVNews*)avNews;

@end
