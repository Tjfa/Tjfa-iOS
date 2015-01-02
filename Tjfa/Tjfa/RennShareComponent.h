//
//  ShareComponent.h
//  ShareComponent
//
//  Created by 杨 飞 on 13-9-13.
//  Copyright (c) 2013年 YangFei. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SDK_VERSION @"1.0"

@class RennMessage;

typedef enum _MessageTarget
{
    To_Talk,
    To_Renren
}
MessageTarget;

/*
<string name="messagecode_1000">人人客户端不存在或现有版本不支持，请下载最新的人人客户端</string>
<string name="messagecode_1001">rennShareComponent实例没有初始化appId,apiKey,secretKey</string>
<string name="messagecode_1002">人人客户端处发送消息失败</string>
<string name="messagecode_1003">发送的消息不能为nil</string>
<string name="messagecode_1010">纯文本信息text字段不能空</string>
<string name="messagecode_1020">缩略图thumbData字段不能为空</string>
<string name="messagecode_1021">纯图片信息thumbData字段与imageUrl字段不能全为空</string>
<string name="messagecode_1022">纯图片信息localPath字段的文件不存在</string>
<string name="messagecode_1030">图文混排信息thumbData,text,title字段不能全为空</string>
<string name="messagecode_1031">图文混排信息url字段不能为空</string>
<string name="messagecode_1032">缩略图大小不能超过40kb</string>
*/

@protocol RennMessageProtocol <NSObject>

-(NSDictionary *) dictValue;
-(NSString *) msgType;
-(NSString *) msgVersion;
-(NSInteger) checkError:(MessageTarget) msgTarget;

@end

@interface RennShareComponent : NSObject

// Init with basic app infomation
+ (void)initWithAppId:(NSString *)appId apiKey:(NSString *)apiKey secretKey:(NSString *)secretKey;
+ (NSInteger) SendMessage:(RennMessage<RennMessageProtocol> *) msg msgTarget:(MessageTarget) msgTarget;

@end


@interface RennMessage : NSObject

@end


//文本消息
@interface RennTextMessage : RennMessage<RennMessageProtocol>

/** 消息标题
 * 长度不超过50字
 */
@property (nonatomic,copy) NSString * title;
/** 文本消息内容
 * 长度不超过2000字
 */
@property (nonatomic,copy) NSString * text;

/** 消息跳转url
 * 长度不能超过2000
 */
@property (nonatomic,copy) NSString * url;
@end


//图片消息
@interface RennImageMessage : RennMessage<RennMessageProtocol>

/** 消息标题
 * 长度不超过50字
 */
@property (nonatomic,copy) NSString * title;
/** 设置消息缩略图的方法
 * 缩略图 大小不能超过40K
 */
@property (nonatomic, retain) NSData   *thumbData;
/** 图片真实数据内容
 * 大小不能超过10M
 */
@property (nonatomic, retain) NSData    *imageData;
/** 图片url
 * 长度不能超过2000字节
 */
@property (nonatomic, retain) NSString  *imageUrl;

@end

//图文消息
@interface RennImgTextMessage : RennMessage<RennMessageProtocol>

/** 设置消息缩略图的方法
 * 缩略图 大小不能超过40K
 */
@property (nonatomic, retain) NSData   *thumbData;
/** 消息标题
 * 长度不超过50字
 */
@property (nonatomic,copy) NSString * title;
/** 消息内容
 * 长度不超过2000字
 */
@property (nonatomic,copy) NSString * desc;
/** 消息跳转url
 * 长度不能超过2000字节
 */
@property (nonatomic,copy) NSString * url;

@end

//视频消息
@interface RennVideoMessage : RennMessage<RennMessageProtocol>

/** 消息标题
 * 长度不超过50字
 */
@property (nonatomic,copy) NSString *title;
/** 消息内容
 * 长度不超过2000字
 */
@property (nonatomic,copy) NSString *description;
/** 视频来源url
 * 长度不能超过2000字节
 */
@property (nonatomic,copy) NSString *url;
/** 视频缩略图
 * 大小不能超过40K
 */
@property (nonatomic, retain) NSData *thumbData;

@end

//语音消息
@interface RennVoiceMessage : RennMessage<RennMessageProtocol>

/** 消息标题
 * 长度不超过50字
 */
@property (nonatomic,copy) NSString *title;
/** 消息内容
 * 长度不超过2000字
 */
@property (nonatomic,copy) NSString *description;
/** 语音来源url
 * 长度不能超过2000字节
 */
@property (nonatomic,copy) NSString *url;
/** 视频缩略图
 * 大小不能超过40K
 */
@property (nonatomic, retain) NSData *thumbData;

@end


@interface NSDictionary (Helpers)
+ (NSDictionary *)dictionaryWithContentsOfData:(NSData *)data;
@end
