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

+ (NSString *)generalVCFStringWithUser:(TJUser *)user
{
    if (user == nil) {
        return @"";
    }
    NSString *vCard = @"";
    
    NSString *lastName = @"";
    if (user.name.length >= 1) {
        lastName = [user.name substringFromIndex:1];
    }

    NSString *firstName = @"";
    if (user.name.length >= 2) {
        firstName = [user.name substringFromIndex:1];
    }
    
    NSString *middleName = @"";
    NSString *prefix = @"";
    NSString *suffix = @"";
    
    vCard = [vCard stringByAppendingFormat:@"BEGIN:VCARD\nVERSION:3.0\nN:%@;%@;%@;%@;%@\n", firstName, lastName, middleName, prefix, suffix];
    vCard = [vCard stringByAppendingFormat:@"TEL;type=CELL:%@\n", user.mobilePhoneNumber];
    
    if (user.avatar) {
        NSData *avatar = [user.avatar getData];
        NSString *avatarString = [[NSString alloc] initWithData:avatar encoding:NSUTF8StringEncoding];
    }
    
    vCard = [vCard stringByAppendingString:@"END:VCARD"];
    
    return vCard;
}

@end
