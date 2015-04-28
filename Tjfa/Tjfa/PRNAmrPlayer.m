//
//  PRNAmrPlayer.m
//  AMRMedia
//
//  Created by 翁阳 on 14/11/21.
//  Copyright (c) 2014年 prinsun. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <objc/runtime.h>

#import "PRNAmrPlayer.h"
#import "amr_wav_converter.h"

@interface PRNAmrPlayer () <AVAudioPlayerDelegate>
{
    AVAudioPlayer *audioPlayer;
    
    NSMutableSet *audioPlayers;
}

@end

@implementation PRNAmrPlayer


- (instancetype)init
{
    self = [super init];
    if (self) {
        audioPlayers = [[NSMutableSet alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(sensorStateChange:)
                                                     name:UIDeviceProximityStateDidChangeNotification
                                                   object:nil];

    }
    return self;
}


- (void)playWithURL:(NSURL *)fileURL
{
    [self playWithURL:fileURL finished:nil];
}

- (void)playWithURL:(NSURL *)fileURL finished:(void (^)(void))callback
{
    
    NSString *amrFileUrlString = fileURL.absoluteString;
    NSString *wavFileUrlString = [amrFileUrlString stringByAppendingString:@".wav"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:wavFileUrlString]) {
        amr_file_to_wave_file([amrFileUrlString cStringUsingEncoding:NSASCIIStringEncoding],
                              [wavFileUrlString cStringUsingEncoding:NSASCIIStringEncoding]);
    }
    
    
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:wavFileUrlString] error:nil];
    
    [audioPlayers addObject:audioPlayer];
    
    if (callback) {
        audioPlayer.delegate = self;
        objc_setAssociatedObject(audioPlayer, "callback", callback, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    
    [audioPlayer play];
}


- (void)stop
{
    [audioPlayer stop];
}


- (void)setSpeakMode:(BOOL)speakMode
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        AVAudioSessionPortOverride portOverride = speakMode ? AVAudioSessionPortOverrideSpeaker : AVAudioSessionPortOverrideNone;
        [[AVAudioSession sharedInstance] overrideOutputAudioPort:portOverride error:nil];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UInt32 route = speakMode ? kAudioSessionOverrideAudioRoute_Speaker : kAudioSessionOverrideAudioRoute_None;
        AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(route), &route);
#pragma clang diagnostic pop
        
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - AVAudioPlayerDelegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    void (^callback)(void) = objc_getAssociatedObject(player, "callback");
    if (callback) {
        callback();
        objc_setAssociatedObject(player, "callback", nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    [audioPlayers removeObject:player];
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    [player stop];
}

-(void)sensorStateChange:(NSNotificationCenter *)notification;
{
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗（省电啊）
    if ([[UIDevice currentDevice] proximityState] == YES)
    {
        NSLog(@"Device is close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        
    }
    else
    {
        NSLog(@"Device is not close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}


@end