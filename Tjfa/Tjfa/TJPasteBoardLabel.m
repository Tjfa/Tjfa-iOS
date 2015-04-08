//
//  TJPasteBoardLabel.m
//  Tjfa
//
//  Created by 邱峰 on 4/9/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import "TJPasteBoardLabel.h"

@implementation TJPasteBoardLabel

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return (action == @selector(copy:));
}

- (void)copy:(id)sender
{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.text;
}

@end
