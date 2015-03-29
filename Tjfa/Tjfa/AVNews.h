//
//  AVNews.h
//  Tjfa
//
//  Created by 邱峰 on 9/22/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@interface AVNews : AVObject <AVSubclassing>

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

@end
