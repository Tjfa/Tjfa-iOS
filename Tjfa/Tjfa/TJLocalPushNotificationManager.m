//
//  TJLocalPushNotification.m
//  Tjfa
//
//  Created by 邱峰 on 4/18/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import "TJLocalPushNotificationManager.h"
#import "TJMatch.h"
#import <YapDatabase.h>
#import "NSDate+Date2Str.h"

@interface TJLocalPushNotificationManager()

@property (nonatomic, strong) YapDatabase *database;

@property (nonatomic, strong) YapDatabaseConnection *connection;

@end

@implementation TJLocalPushNotificationManager

+ (instancetype)sharedLocalPushNotificationManager
{
    static dispatch_once_t onceToken;
    static TJLocalPushNotificationManager *instance;
    
    dispatch_once(&onceToken, ^() {
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.database = [[YapDatabase alloc] initWithPath:[self databasePath]];
        self.connection = [self.database newConnection];
    }
    return self;
}

#pragma mark - Getter & Setter

- (NSString *)databasePath
{
    NSString *databaseName = @"TJFA_Remind.sqlite";
    
    NSURL *baseURL = [[NSFileManager defaultManager] URLForDirectory:NSApplicationSupportDirectory
                                                            inDomain:NSUserDomainMask
                                                   appropriateForURL:nil
                                                              create:YES
                                                               error:NULL];
    
    NSURL *databaseURL = [baseURL URLByAppendingPathComponent:databaseName isDirectory:NO];
    
    return databaseURL.filePathURL.path;
}

#pragma mark - Public Method

- (NSDate *)getMatchRemindTime:(TJMatch *)match
{
    __block NSDate *date;
    [self.connection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
        NSString *collection = [[NSString alloc] initWithFormat:@"%@",match.matchId];
        date = [transaction objectForKey:@"remindDate" inCollection:collection];
    }];
    return date;
}

- (void)asyncGetMatchRemindTime:(TJMatch *)match complete:(void (^)(NSDate *))complete
{
    [self.connection asyncReadWithBlock:^(YapDatabaseReadTransaction *transation) {
        NSString *collection = [[NSString alloc] initWithFormat:@"%@",match.matchId];
        NSDate *date = [transation objectForKey:@"remindDate" inCollection:collection];
        if (complete) {
            complete(date);
        }
    }];
}

- (BOOL)addMatchRemindNotification:(TJMatch *)match teamAName:(NSString *)teamA teamBName:(NSString *)teamB date:(NSDate *)date
{
    if (match == nil) {
        return NO;
    }
    
    [self.connection readWriteWithBlock:^(YapDatabaseReadWriteTransaction* transaction) {
        NSString *collection = [[NSString alloc] initWithFormat:@"%@",match.matchId];
        [transaction setObject:date forKey:@"remindDate" inCollection:collection];
        [transaction setObject:match.date forKey:@"date" inCollection:collection];
        [transaction setObject:teamA forKey:@"teamA" inCollection:collection];
        [transaction setObject:teamB forKey:@"teamB" inCollection:collection];
    }];
    
    return YES;
}

- (void)asyncAddMatchRemindNotification:(TJMatch *)match teamAName:(NSString *)teamA teamBName:(NSString *)teamB date:(NSDate *)date complete:(void (^)(BOOL))complete
{
    if (match == nil) {
        complete(NO);
    }
    
    [self.connection asyncReadWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        NSString *collection = [[NSString alloc] initWithFormat:@"%@",match.matchId];
        [transaction setObject:date forKey:@"remindDate" inCollection:collection];
        [transaction setObject:match.date forKey:@"date" inCollection:collection];
        [transaction setObject:teamA forKey:@"teamA" inCollection:collection];
        [transaction setObject:teamB forKey:@"teamB" inCollection:collection];
        complete(YES);
    }];
}

- (BOOL)removeMatchRemindNotification:(TJMatch *)match
{
    if (match == nil) {
        return NO;
    }
    
    [self.connection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        NSString *collection = [[NSString alloc] initWithFormat:@"%@",match.matchId];
        [transaction removeAllObjectsInCollection:collection];
    }];
    return YES;
}

- (void)asyncRemoveMatchRemindNotification:(TJMatch *)match complete:(void (^)(BOOL))complete
{
    if (match == nil) {
        complete(NO);
    }
    else {
        [self.connection asyncReadWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
            NSString *collection = [[NSString alloc] initWithFormat:@"%@",match.matchId];
            [transaction removeAllObjectsInCollection:collection];
            complete(YES);
        }];
    }
}

//- (NSArray *)getAllRemindMatchIds
//{
//    __block NSArray *result = nil;
//    [self.connection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
//        result = [transaction allCollections];
//    }];
//    return result;
//}

//- (void)asyncGetAllRemindMatchIds:(void (^)(NSArray *))complete
//{
//    if (complete == nil) {
//        return;
//    }
//    [self.connection asyncReadWithBlock:^(YapDatabaseReadTransaction *transaction) {
//        NSArray *result = [transaction allKeysInCollection:self.remindCollection];
//        complete(result);
//    }];
//}
//
#pragma mark - Local Push Notification

- (void)setupAllLocalPushNotifications
{
    [self cancelAllLocalPushNotifications];
    
    NSDate *nowDate = [NSDate date];
    [self.connection asyncReadWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        NSArray *collections = [transaction allCollections];
        
        for (NSString *collection in collections) {
            NSDate *remindDate = [transaction objectForKey:@"remindDate" inCollection:collection];
            NSDate *date = [transaction objectForKey:@"date" inCollection:collection];
            NSString *teamAName = [transaction objectForKey:@"teamA" inCollection:collection];
            NSString *teamBName = [transaction objectForKey:@"teamB" inCollection:collection];
            
            if ([remindDate compare:nowDate] == NSOrderedAscending) {
                [transaction removeAllObjectsInCollection:collection];
            }
            else {
                UILocalNotification *notification = [[UILocalNotification alloc] init];
                notification.fireDate = remindDate;
                notification.alertTitle = @"比赛提醒";
                notification.alertBody = [[NSString alloc] initWithFormat:@"%@ 与 %@ 的比赛将在 %@ 开始,快去做好准备吧", teamAName, teamBName, [date date2str]];
                [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            }

        }
    }];
}

- (void)cancelAllLocalPushNotifications
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

@end
