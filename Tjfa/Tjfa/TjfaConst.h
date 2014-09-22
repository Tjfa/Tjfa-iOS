//
//  TjfaConst.h
//  Tjfa
//
//  Created by 邱峰 on 9/22/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#ifndef Tjfa_TjfaConst_h
#define Tjfa_TjfaConst_h

#define AVOS_APP_ID @"n2iby57nxdhh1cnqw27eocg6lkujbovtgvb7ezzjtb9wpqqf"
#define AVOS_CLIENT_KEY @"ks5u25gdqcm5laox6oj9gfq195p4ymfaytb9eix5fb6yq6nt"

#import "AVModule.h"
#import "UIColor+AppColor.h"

#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloudSNS/AVOSCloudSNS.h>
#import <CoreData+MagicalRecord.h>

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define DEFAULT_LIMIT 20

#endif
