//
//  TJStreamPlayer.m
//  Tjfa
//
//  Created by 邱峰 on 4/19/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import "TJStreamPlayer.h"
#import "TJAudioFile.h"

@interface TJStreamPlayer()

@property (nonatomic, strong) DOUAudioStreamer *audioStreamer;

@end

@implementation TJStreamPlayer

- (void)playUrl:(NSURL *)url
{
    TJAudioFile *file = [[TJAudioFile alloc] initWithUrl:url];
    [self.audioStreamer stop];
    
    self.audioStreamer = [[DOUAudioStreamer alloc] initWithAudioFile:file];
    
    [self.audioStreamer play];
}

- (void)stop
{
    [self.audioStreamer stop];
    self.audioStreamer = nil;
}

@end
