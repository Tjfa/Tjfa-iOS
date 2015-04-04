//
//  JSQMessagesToolbarButtonFactory+VoiceButton.m
//  Tjfa
//
//  Created by 邱峰 on 4/4/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import "JSQMessagesToolbarButtonFactory+VoiceButton.h"
#import <UIImage+JSQMessages.h>

@implementation JSQMessagesToolbarButtonFactory (VoiceButton)


+ (UIButton *)defaultVoiceButtonItem
{
    UIImage *accessoryImage = [UIImage imageNamed:@"voiceButton"];
    
    UIButton *accessoryButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, accessoryImage.size.width, 32.0f)];
    [accessoryButton setImage:accessoryImage forState:UIControlStateNormal];
    accessoryButton.contentMode = UIViewContentModeScaleAspectFit;
    
    return accessoryButton;
}


@end
