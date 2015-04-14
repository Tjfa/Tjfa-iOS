//
//  TJPersonManager.h
//  Tjfa
//
//  Created by 邱峰 on 4/7/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

@class TJUser;

typedef NS_ENUM(NSInteger, TJMergeCreateToContact) {
    TJMergetToContact = 0,
    TJAddToContact = 1,
    TJMergetOrAddFail = 2,
};

@interface TJPersonManager : NSObject

+ (NSData *)generalVCFStringWithUser:(TJUser *)user;

+ (ABRecordRef)generalWithUser:(TJUser *)user;

+ (TJMergeCreateToContact)mergeOrAddToContactWithUser:(TJUser *)user;

@end
