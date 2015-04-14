//
//  TJVCFFileManager.h
//  Tjfa
//
//  Created by 邱峰 on 4/7/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

@class TJUser;

@interface TJVCFFileManager : NSObject

+ (NSData *)generalVCFStringWithUser:(TJUser *)user;

+ (ABRecordRef)generalWithUser:(TJUser *)user;

@end
