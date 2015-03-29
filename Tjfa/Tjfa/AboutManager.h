//
//  AboutManager.h
//  Tjfa
//
//  Created by 邱峰 on 7/10/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AboutManager : NSObject

/**
 *  please set uiviewcontroller delegate first
 */
@property (nonatomic, weak) UIViewController* instanceController;

/**
 *  singleton instance
 *
 *  @return instance
 */
+ (AboutManager*)sharedAboutManager;

/**
 *   到 app store为我评分
 */
- (void)evaluate;

/**
 *  删除本地数据
 */
- (void)deleteLocalData;

/**
 *  短信分享
 */
- (void)sharedWithMessage;

/**
 *  微信分享到朋友圈
 */
- (void)sharedWithWeiXin;

/**
 *  分享到人人
 */
- (void)sharedWithRenRen;

/**
 *  为我提意见
 */
- (void)gotoSuggestion;

@end
