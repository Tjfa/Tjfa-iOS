//
//  EMMessage+MessageTranform.h
//  Tjfa
//
//  Created by 邱峰 on 4/2/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import "EMMessage.h"
#import "TJUser.h"

@interface EMMessage (MessageTranform)

+ (EMMessage *)generalMessageWithText:(NSString *)text sender:(TJUser *)sender to:(NSString *)emId;

@end
