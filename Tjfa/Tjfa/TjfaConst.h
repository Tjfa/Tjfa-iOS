//
//  TjfaConst.h
//  Tjfa
//
//  Created by 邱峰 on 9/22/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#ifndef Tjfa_TjfaConst_h
#define Tjfa_TjfaConst_h

#if DEBUG
    #define AVOS_APP_ID @"yyy2oocar74kh9kywwg4z9wdqzjelmjs9fsju5fm01r9mkdg"
    #define AVOS_CLIENT_KEY @"v3cdupbp0fcv9b9712qvp45qb0efq6hy0iqttu3nvd80d6ts"
#else
    #define AVOS_APP_ID @"n2iby57nxdhh1cnqw27eocg6lkujbovtgvb7ezzjtb9wpqqf"
    #define AVOS_CLIENT_KEY @"ks5u25gdqcm5laox6oj9gfq195p4ymfaytb9eix5fb6yq6nt"
#endif

#if DEUBG
    #define EASE_MOB_APP_KEY @"tongjiuniversity#tjfadebug"
    #define EASE_MOB_APNS @"tjfa_debug"
#else
    #define EASE_MOB_APP_KEY @"tongjiuniversity#tjfa"
    #define EASE_MOB_APNS @"tjfa"
#endif


#define DEFAULT_LIMIT 20

#endif
