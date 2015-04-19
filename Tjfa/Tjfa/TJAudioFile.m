//
//  TJAudioFile.m
//  Tjfa
//
//  Created by 邱峰 on 4/19/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import "TJAudioFile.h"
#import <DOUAudioStreamer.h>

@interface TJAudioFile()

@property (nonatomic, strong) NSURL *path;

@end

@implementation TJAudioFile

- (instancetype)initWithUrl:(NSURL *)url
{
    if (self = [super init]) {
        self.path = url;
    }
    return self;
}

#pragma mark - Delegate

- (NSURL *)audioFileURL
{
    return self.path;
}

@end
