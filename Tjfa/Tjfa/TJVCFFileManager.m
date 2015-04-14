//
//  TJVCFFileManager.m
//  Tjfa
//
//  Created by 邱峰 on 4/7/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import "TJVCFFileManager.h"
#import "TJUser.h"
@implementation TJVCFFileManager

+ (NSData *)generalVCFStringWithUser:(TJUser *)user
{
    ABRecordRef person = [self generalWithUser:user];
    NSArray *individual = [[NSArray alloc]initWithObjects:(__bridge id)(person), nil];
    CFArrayRef arrayRef = (__bridge CFArrayRef)individual;
    NSData *vcards = (__bridge NSData *)ABPersonCreateVCardRepresentationWithPeople(arrayRef);
    
    return vcards;
}

+ (ABRecordRef)generalWithUser:(TJUser *)user
{
    if (user == nil) {
        return nil;
    }
    
    ABRecordRef person = ABPersonCreate();

    
    NSString *lastName = @"";
    if (user.name.length >= 1) {
        lastName = [user.name substringToIndex:1];
    }
    
    NSString *firstName = @"";
    if (user.name.length >= 2) {
        firstName = [user.name substringFromIndex:1];
    }
    
    ABRecordSetValue(person, kABPersonPhoneProperty, (__bridge CFTypeRef)(user.mobilePhoneNumber), nil);
    ABRecordSetValue(person, kABPersonFirstNameProperty, (__bridge CFTypeRef)(firstName), nil);
    ABRecordSetValue(person, kABPersonLastNameProperty, (__bridge CFTypeRef)(lastName), nil);
    if (user.avatar) {
        NSData *avatar = [user.avatar getData];
        if (avatar) {
            ABPersonSetImageData(person, (__bridge CFDataRef)(avatar), nil);
        }
    }
    
    return person;
}

@end
