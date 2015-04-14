//
//  TJPersonManager.m
//  Tjfa
//
//  Created by 邱峰 on 4/7/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import "TJPersonManager.h"
#import "TJUser.h"
@implementation TJPersonManager

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

+ (TJMergeCreateToContact)mergeOrAddToContactWithUser:(TJUser *)user
{
    ABRecordRef person = [self generalWithUser:user];
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool greanted, CFErrorRef error) {
        dispatch_semaphore_signal(sema);
    });
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    if (addressBook == nil) {
        return TJMergetOrAddFail;
    }
    
    CFArrayRef contacts = ABAddressBookCopyArrayOfAllPeople(addressBook);
    for (int i = 0; i< CFArrayGetCount(contacts); i++) {
        ABRecordRef oldPerson = CFArrayGetValueAtIndex(contacts, i);
        CFTypeRef firstName = ABRecordCopyValue(oldPerson, abreco)
    }
    
    return TJAddToContact;
}

@end
