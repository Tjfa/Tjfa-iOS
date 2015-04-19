//
//  TJAudioFile.h
//  Tjfa
//
//  Created by 邱峰 on 4/19/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DOUAudioStreamer.h>

@interface TJAudioFile : NSObject <DOUAudioFile>

- (instancetype)initWithUrl:(NSURL *)url;

@end
