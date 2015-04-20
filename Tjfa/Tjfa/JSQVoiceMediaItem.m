//
//  JSQVoiceMediaItem.m
//  Tjfa
//
//  Created by 邱峰 on 4/6/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import "JSQVoiceMediaItem.h"

@implementation JSQVoiceMediaItem

- (CGSize)mediaViewDisplaySize
{
    return CGSizeMake(44, 44);
}

- (UIView *)mediaView
{
    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat_record"]];
}

@end
