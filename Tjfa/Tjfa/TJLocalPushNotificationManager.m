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

@interface TJLocalPushNotificationManager()

@property (nonatomic, strong) YapDatabase *database;

@property (nonatomic, strong) YapDatabaseConnection *connection;

@property (nonatomic, strong) NSString *remindCollection;

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

- (NSString *)remindCollection
{
    if (_remindCollection == nil) {
        _remindCollection = @"YapDatabase_RemindCollection";
    }
    return _remindCollection;
}

#pragma mark - Public Method

- (NSDate *)getMatchRemindTime:(TJMatch *)match
{
    __block NSDate *date;
    [self.connection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
        date = [transaction objectForKey:match.objectId inCollection:self.remindCollection];
    }];
    return date;
}

- (void)asyncGetMatchRemindTime:(TJMatch *)match complete:(void (^)(NSDate *))complete
{
    [self.connection asyncReadWithBlock:^(YapDatabaseReadTransaction *transation) {
        NSDate *date = [transation objectForKey:match.objectId inCollection:self.remindCollection];
        if (complete) {
            complete(date);
        }
    }];
}

- (BOOL)addMatchRemindNotification:(TJMatch *)match date:(NSDate *)date
{
    if (match == nil) {
        return NO;
    }
    
    [self.connection readWriteWithBlock:^(YapDatabaseReadWriteTransaction* transaction) {
        [transaction setObject:date forKey:match.objectId inCollection:self.remindCollection];
    }];
    
    return YES;
}

- (void)asyncAddMatchRemindNotification:(TJMatch *)match date:(NSDate *)date complete:(void (^)(BOOL))complete
{
    if (match == nil) {
        complete(NO);
    }
    
    [self.connection asyncReadWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        [transaction setObject:date forKey:match.objectId inCollection:self.remindCollection];
        complete(YES);
    }];
}

- (BOOL)removeMatchRemindNotification:(TJMatch *)match
{
    if (match == nil) {
        return NO;
    }
    
    [self.connection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        [transaction removeObjectForKey:match.objectId inCollection:self.remindCollection];
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
            [transaction removeObjectForKey:match.objectId inCollection:self.remindCollection];
            complete(YES);
        }];
    }
}

#pragma mark - Local Push Notification

- (void)setupAllLocalPushNotifications
{
    NSDate *nowDate = [NSDate date];
    [self.connection asyncReadWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        NSMutableArray *removeShedule = [NSMutableArray array];
        [transaction enumerateKeysAndObjectsInCollection:self.remindCollection usingBlock:^(NSString *key, id object, BOOL *stop) {
            NSDate *remindDate = object;
            if ([remindDate compare:nowDate] == NSOrderedAscending) {
                [removeShedule addObject:key];
            }
            else {
#warning add code here
                //to do
                
            }
        }];
        
        for (NSString *key in removeShedule) {
            [transaction removeObjectForKey:key inCollection:self.remindCollection];
        }
    }];
}

- (void)cancelAllLocalPushNotifications
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

@end
